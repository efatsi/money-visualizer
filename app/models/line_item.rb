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

  def self.months
    LineItem.pluck(:month_year).uniq.sort_by do |dm|
      Date.new(dm.split("/").last.to_i, dm.split("/").first.to_i)
    end
  end

  private

  def set_month_year
    self.month_year = "#{date.month}/#{date.year}"
  end
end
