module RecipeIngredientsHelper
  ##############################################################################
  # Creates a human readable fraction for the recipe ingredient quantity from 
  # the float value.
  #
  # Entry: ing is the recipe ingredient
  #
  #  Exit: frac returned as string
  ##############################################################################
  def fractionalize(ing)
    ############################################################################
    # The to_fraction function provided by http://rubygems.org/gems/fraction
    # converts a float value into a matrix hash of the fraction elements [0,1,2]
    # as: [numerator,denominator,(float)remainder] only elements 0-1 are used to
    # display fraction to page.
    ############################################################################
    frac = ing.quantity.to_fraction
    # if whole number just display numerator
    if(frac[1] == 1)
      "#{frac[0]}"
    #else display fraction
    else
      "#{frac[0]}/#{frac[1]}"
    end
  end
end
