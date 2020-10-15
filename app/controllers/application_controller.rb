class ApplicationController < ActionController::Base

  private

  def range
    (params[:range] || 6).to_i
  end
  helper_method :range
end
