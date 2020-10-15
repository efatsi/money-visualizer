class LineItem < ApplicationRecord
  belongs_to :category

  validates :title,
    :amount,
    :date,
    :source,
    :category,
    :month_year,
    presence: true

  before_validation :set_month_year

  scope :charges, -> { where("amount < 0") }

  def self.months
    LineItem.pluck(:month_year).uniq.sort_by do |dm|
      Date.new(dm.split("/").last.to_i, dm.split("/").first.to_i)
    end
  end

  def self.average(range)
    range = (range || 12).to_i
    set = gather_all(range)

    (set.sum / set.count).round(2)
  end

  def self.gather_all(range)
    months.last(range).map do |month|
      self.charges.where(month_year: month).sum(&:amount)
    end
  end

  def self.variation(range)
    (std_dev(range) / average(range) * 100).round.abs
  rescue
    0
  end

  def self.std_dev(range)
    range = (range || 12).to_i
    set = gather_all(range)

    mean = (set.sum / set.count)
    sum = set.inject(0) {|accum, i| accum +(i-mean)**2 }
    sample_variance = sum/(range - 1).to_f
    Math.sqrt(sample_variance).round(2)
  end

  def weekday_integer
    (date.wday + 2) % 8
  end

  private

  def set_month_year
    self.month_year = "#{date.month}/#{date.year}"
  end
end
