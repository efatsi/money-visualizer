class MonthsController < ApplicationController
  def show
  end

  private

  def line_items
    @line_items ||= begin
      scope = LineItem.where(month_year: month)

      if category
        scope = scope.where(category: category)
      end

      scope
    end
  end
  helper_method :line_items

  def month
    params[:month]
  end
  helper_method :month

  def category
    @category ||= if params[:category_id]
      Category.find(params[:category_id])
    end
  end
  helper_method :category
end
