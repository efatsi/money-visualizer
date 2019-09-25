class HomeController < ApplicationController

  private

  def chart_data
    [
      {
        name: "Average",
        data: Category.expenses.inject({}) do |hash, category|
          hash.merge(category.name => category.average(range).abs)
        end
      }
    ] + LineItem.months.last(3).map do |month|
      {
        name: month,
        data: Category.expenses.inject({}) do |hash, category|
          hash.merge(category.name => category.line_items.where(month_year: month).sum(&:amount).abs)
        end
      }
    end
  end
  helper_method :chart_data
end
