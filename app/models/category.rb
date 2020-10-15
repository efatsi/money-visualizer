class Category < ApplicationRecord
  has_many :line_items

  scope :expenses, -> { where.not(name: ["Mortgage", "Income", "Reimbursements"]) }

  validates :name, presence: true

  def self.for_dashboard(range)
    [find_by(name: "Income")] + self.where.not(name: "Income").sort_by do |category|
      category.gather_all(range).sum.abs
    end.reverse
  end

  def to_s
    name
  end

  def average(range)
    range = (range || 12).to_i
    set = gather_all(range)

    (set.sum / set.count).round(2)
  end

  def variation(range)
    (std_dev(range) / average(range) * 100).round.abs
  rescue
    0
  end

  def std_dev(range)
    range = (range || 12).to_i
    set = gather_all(range)

    mean = (set.sum / set.count)
    sum = set.inject(0) {|accum, i| accum +(i-mean)**2 }
    sample_variance = sum/(range - 1).to_f
    Math.sqrt(sample_variance).round(2)
  end

  def gather_all(range)
    months = LineItem.months.last(range)

    months.map do |month|
      line_items.where(month_year: month).sum(&:amount)
    end
  end
end
