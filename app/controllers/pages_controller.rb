#
class PagesController < ApplicationController
  before_filter :authenticate, :only =>  [:feeds]



  # GET /home
  # GET /pages/home
  # a web page to present Raspberry Cook
  def home
    @jsonld = RaspberryCookFundation.to_jsonld 'WebSite'

    @recipes = Recipe.order(id: 'DESC').limit(20)
    forked_recipe = Recipe.where.not(root_recipe_id: 0).order(id: 'DESC').take
    @root_recipe = forked_recipe.root_recipe if forked_recipe
    @forked_recipe = [@root_recipe, forked_recipe]
  end


  # GET /about
  # GET /pages/about
  # a web page to present Raspberry Cook
  def about
    @title = "A propos de Raspberry Cook"
    @description = "Apprenez en d'avantages à propos du projet Raspberry Cook"

    @jsonld = RaspberryCookFundation.to_jsonld 'WebSite'
    @recipes = Recipe.where.not(image: nil).order(id: 'DESC').limit(3)
  end


  # GET /credits
  # GET /pages/credits
  # a web page to thank all contributors on this amazing project
  def credits
    @title = 'Crédits'
    @description = "Raspberry Cook est le fruit de vous tous!"

    @jsonld = RaspberryCookFundation.to_jsonld 'WebSite'
  end


  # GET /feeds
  # GET /pages/feeds
  # allow usser to consult what he missed on Raspberry Cook
  def feeds
    @title = 'Actualités'
    @description = 'Tout ce que vous n\'avez pas ecore vu'

    @recipes_feeds = Recipe.unread_by(current_user).paginate(:page => params[:page]).order('id DESC')
    @unread_comments = Comment.unread_by(current_user)
    Comment.mark_as_read! :all, for: current_user
  end


  # GET /fridge
  # GET /pages/fridge
  # POST /fridge
  # POST /pages/fridge
  def fridge
    @title = 'Vider mon frigo'
    @description = 'Cuisinez avec tout ce qui traine dans votre frigo'

    recipes = nil

    if params[:ingredients]
      ingredients = params[:ingredients].split('_')
      query = []
      ingredients_params = []
      ingredients.map{|ing|
        query << "ingredients LIKE ?"
        ingredients_params << "%#{ing}%"
      }
      recipes = Recipe.where(query.join(" AND "), *ingredients_params)
    else
      recipes = Recipe.all
    end
    @recipes = recipes.paginate :page => params[:page]
  end



end
