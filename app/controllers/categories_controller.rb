class CategoriesController < ApplicationController
  def show
  end

  private

  def category
    @category ||= Category.find(params[:id])
  end
  helper_method :category

  def chart_data
    [
      {
        name: "Average",
        data: LineItem.months.last(range).inject({}) do |hash, month|
          hash.merge(month => category.average(range).abs)
        end
      },
      {
        name: "Months",
        data: LineItem.months.last(range).inject({}) do |hash, month|
          hash.merge(month => category.line_items.where(month_year: month).sum(&:amount).abs)
        end
      }
    ]
  end
  helper_method :chart_data
end
