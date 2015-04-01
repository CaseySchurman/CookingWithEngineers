/*
/*******************************************
* Alexander Tappin
* Ingredients Jquery Ajax
* 2/9/15
********************************************
def getmatchingingredients
   @query = request.filtered_parameters['ingredients']
   @ingredients = []
   Ingredient.where("name like :name", {name: "#{@query}%"}).find_each do |ingredient|
      @ingredients << ingredient
   end
   
   return @ingredients
end

$(#"some_field").keyup()

$.ajax({
   type: 'GET', // or 'POST', 'PUT', NOT sure yet which one I want to use
   url: '/ingredients/getingredients index.html.erb',
   data: { productId: $('#product_id') },
   success: function(response)
   {
       // assuming data comes back as JSON so like: { ingredient: salt }
       $('#ingredient').val(response.ingredients);
   }
});
*/