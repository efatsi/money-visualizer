class ApplicationController < ActionController::Base

  private

  def range
    (params[:range] || 12).to_i
  end
  helper_method :range
end
