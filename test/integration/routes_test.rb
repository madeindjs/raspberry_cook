require 'test_helper'

class RoutesTest < ActionController::TestCase

  test "recipes global route test" do
    assert_recognizes({controller: "recipes", action: "index"}, {path: '/recipes', method: :get})
    assert_recognizes({controller: "recipes", action: "shuffle"}, {path: '/recipes/shuffle', method: :get})
    assert_recognizes({controller: "recipes", action: "update", id: "1"}, {path: '/recipes/1', method: :patch})
  end

  test "recipes CRUD route test" do
    assert_recognizes({controller: "recipes", action: "show", id: "1"}, {path: '/recipes/1', method: :get})
    assert_recognizes({controller: "recipes", action: "update", id: "1"}, {path: '/recipes/1', method: :patch})
  end

  test "recipes socials route test" do
    assert_recognizes({controller: "recipes", action: "fork", id: "1"}, {path: '/recipes/1/fork', method: :get})
    assert_recognizes({controller: "recipes", action: "fork", id: "1"}, {path: '/recipes/1/fork', method: :post})
    assert_recognizes({controller: "recipes", action: "save", id: "1"}, {path: '/recipes/1/save', method: :get})
  end


  test "sessions route test" do
    assert_routing "/signout", { controller: "sessions", action: "destroy" }
  end


  test "pages route test" do
    assert_recognizes({controller: "pages", action: "fridge"}, {path: '/fridge', method: :get})
    assert_recognizes({controller: "pages", action: "feeds"}, {path: '/feeds', method: :get})
    assert_recognizes({controller: "pages", action: "home"}, {path: '/home', method: :get})
    assert_recognizes({controller: "pages", action: "infos"}, {path: '/infos', method: :get})
    assert_recognizes({controller: "pages", action: "credits"}, {path: '/credits', method: :get})
  end

end