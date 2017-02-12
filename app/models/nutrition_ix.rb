class NutritionIx
  include HTTParty

  attr_reader :search, :line_delimited

  ALLOWED_KEYS = [
    :food_name,
    :serving_qty,
    :serving_unit,
    :serving_weight_grams,
    :nf_calories,
    :nf_total_fat,
    :nf_saturated_fat,
    :nf_cholesterol,
    :nf_sodium,
    :nf_total_carbohydrate,
    :nf_dietary_fiber,
    :nf_sugars,
    :nf_protein,
    :nf_potassium,
    :ndb_no,
  ]

  base_uri "https://trackapi.nutritionix.com"

  def initialize(search = "", line_delimited = false)
    @search = search
    @line_delimited = line_delimited
  end

  def errors?
    data[:message] ? true : false
  end

  def messages
    data[:message] || "Your search was successful!"
  end

  def foods
    return [] if errors?

    @foods ||= parse_foods
  end

  def search=(search)
    @search = search
  end

  def line_delimited=(line_delimited)
    @line_delimited = line_delimited
  end

  def reload!
    @data = call_api
    @foods = nil
  end

  private
  def parse_foods
    @foods = data[:foods].collect do |food|
      tag_id = food[:tags][:tag_id]

      new_hash = self.class.filter_keys(food, ALLOWED_KEYS)
      new_hash[:tag_id] = tag_id

      OpenStruct.new(new_hash)
    end
  end

  def data
    @data ||= call_api
  end

  def call_api
    response = self.class.post(
      "/v2/natural/nutrients", headers: headers, body: body
    ).parsed_response

    response.deep_symbolize_keys!
  end

  def headers
    {
      "Content-Type" => "application/json",
      "x-app-id" => ENV["NUTRITION_IX_ID"],
      "x-app-key" => ENV["NUTRITION_IX_APP"]
    }
  end

  def body
    {
      :query => @search,
      :line_delimited => @line_delimited
    }.to_json
  end

  def self.filter_keys(hash, allow = [])
    hash ||= {}

    hash.keep_if do |key, value|
      allow.include?(key)
    end

    hash.transform_keys do |key|
      if key.to_s.start_with?("nf_")
        key.to_s.sub("nf_", "").to_sym
      else
        key
      end
    end
  end
end
