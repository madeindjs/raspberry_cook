require 'test_helper'

class RecipeTest < ActiveSupport::TestCase

  test "should found one recipe" do
    params = {name: 'to_search', ingredients: 'to_search', page: 1}
    assert Recipe.search(params).one?
  end

  test "should not found one recipe" do
    params = {name: 'not_to_search', ingredients: 'to_search' , page: 1}
    assert Recipe.search(params).empty?
  end

  test "should fork the recipe" do
    # create a recipe & fork it
    recipe = recipes(:two)
    forked_recipe = recipe.fork 99
    # check if recipe was added
    assert_difference('Recipe.count') do
      forked_recipe.save
    end
    # check if recipe can be find by user id
    recipe_searched = Recipe.find_by user_id: 99
    assert_equal recipe_searched , forked_recipe
  end

  test "forked recipe should be respond as forked" do
    recipe = recipes(:two)
    forked_recipe = recipe.fork 2
    assert forked_recipe.forked?
    assert_equal recipe, forked_recipe.root_recipe
  end

  # PICTURE AREA

  test "recipe should return default picture as picture" do
    recipe = recipes(:two)
    assert_equal 'default.svg', recipe.true_image_url
    assert_not recipe.has_image?
  end

  test "recipe should return default picture as thumb" do
    recipe = recipes(:two)
    assert_equal 'default.svg', recipe.true_thumb_image_url
  end

  test "if forked recipe have not picture, it should return parent's picture" do
    recipe = recipes(:two)
    # set a picture & fork the recipe
    picture_url = File.open(Rails.root.join("app/assets/images/default.svg"))
    recipe.image = picture_url
    forked_recipe = recipe.fork 2
    # compare only the filename
    assert_equal forked_recipe.true_image_url.split('/').last, recipe.image.url.split('/').last
    assert recipe.has_image?
  end

  test "sould return the good average for the rate" do
    pasta = recipes(:pasta)
    assert_equal 3, pasta.rate
  end

  test "sould return 0 if recipe have not comment" do
    new_recipe = Recipe.create user_id: 8 , name:"a recipe without comment :("
    assert_equal 0, new_recipe.rate
  end

  test "should return all types" do
    assert_equal  ['Entrée', 'Plat', 'Dessert', 'Cocktail', 'Apéritif'], Recipe.types
  end

  test "should return all seasons" do
    assert_equal  ['Toutes', 'Printemps', 'Eté', 'Automne', 'Hiver'], Recipe.seasons
  end

  test "should fail to import recipe (url not valid)" do
    assert_raise(ArgumentError){  Recipe.import "http://google.com", nil }
  end

  test "should import a recipe from marmiton" do

    assert_difference('Recipe.count') do

      recipe_imported =  Recipe.import "http://www.marmiton.org/recettes/recette_paupiettes-de-veau-en-cocotte_18361.aspx", 1
      # check if recipe founded is a recipe
      assert_instance_of Recipe,  recipe_imported
      # check if informations are correct
      assert_equal 'Paupiettes de veau en cocotte', recipe_imported.name
      assert_not_nil recipe_imported.steps
      assert_not_nil recipe_imported.ingredients
      assert_not_nil recipe_imported.t_baking
      assert_not_nil recipe_imported.t_cooking
      assert_equal 1, recipe_imported.user_id
    end
  end

  test "Should import the marmiton picture" do
    recipe_imported =  Recipe.import "http://www.marmiton.org/recettes/recette_paupiettes-de-veau-en-cocotte_18361.aspx", 1
    assert_not_nil recipe_imported.true_image_url
  end

  test "should increment count of views" do
    recipe = Recipe.create name: 'test', user_id: 1

    assert_difference('recipe.views.count',1) do
      assert recipe.add_view 1
    end
  end


  test "should get most viewed recipe" do
    Recipe.order(views: :desc)
  end


  test "should export recipe to jsonld" do
    recipe = Recipe.new
    recipe.id = 1
    recipe.to_jsonld
  end

end
