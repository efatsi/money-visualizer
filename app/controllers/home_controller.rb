class HomeController < ApplicationController

  private

  def random_data
    {6=>15, 12=>40, 3=>24, 8=>9, 11=>19, 7=>3, 9=>14, 13=>10, 10=>40, 1=>87, 5=>9, 4=>11, 2=>34}
  end
  helper_method :random_data
end
