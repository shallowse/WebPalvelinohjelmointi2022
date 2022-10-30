class Style < ApplicationRecord
  has_many :beers

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  def to_s
    name.to_s
  end

  # TODO: refactor
  # Uses same code as model/brewery.rb
  def self.top(num)
    return [] unless num > 0

    collect = []
    Style.all.each do |style|
      avg_sum_per_style = []
      style.beers.each do |beer|
        avg_sum_per_style.append(beer.average_rating)
      end

      avg_sum_per_style = [0] if avg_sum_per_style.empty?

      collect.append(OpenStruct.new(name: style.name,
                                    rating: avg_sum_per_style.sum.to_f / avg_sum_per_style.count))
    end

    collect.sort_by! { |a| -a.rating }
    collect[0...num]
  end
end
