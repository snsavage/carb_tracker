# NutritionIx handles interaction with the NutrionIx API.
class NutritionIx
  include HTTParty

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
    :tag_id
  ].freeze

  attr_accessor :search, :line_delimited

  def initialize(search = '', line_delimited = true)
    self.class.base_uri 'https://trackapi.nutritionix.com'
    @search = search
    @line_delimited = line_delimited
  end

  def messages
    if search == ''
      'Please provide a search term'
    else
      data[:message] || 'Your search was successful!'
    end
  end

  def foods
    return [] if errors?

    parse_foods
  end

  def data
    @data ||= call_api
  end

  def reload!
    @data = call_api
  end

  def errors?
    data[:message] ? true : false
  end

  private

  def parse_foods
    parse = data[:foods].deep_dup

    @foods = parse.collect do |food|
      food[:tag_id] = food[:tags][:tag_id]

      self.class.filter_keys!(food, ALLOWED_KEYS)
      self.class.remove_nf_from_keys!(food)

      food
    end
  end

  def call_api
    response = self.class.post(
      '/v2/natural/nutrients', headers: headers, body: body
    ).parsed_response

    response.deep_symbolize_keys!
  end

  def headers
    {
      'Content-Type' => 'application/json',
      'x-app-id' => ENV['NUTRITION_IX_ID'],
      'x-app-key' => ENV['NUTRITION_IX_APP']
    }
  end

  def body
    {
      query: @search,
      line_delimited: @line_delimited
    }.to_json
  end

  class << self
    def filter_keys!(hash, allow = [])
      hash.keep_if do |key, _value|
        allow.include?(key)
      end
    end

    def remove_nf_from_keys!(hash)
      hash.transform_keys! do |key|
        key.to_s.start_with?('nf_') ? key.to_s.sub('nf_', '').to_sym : key
      end
    end
  end
end
