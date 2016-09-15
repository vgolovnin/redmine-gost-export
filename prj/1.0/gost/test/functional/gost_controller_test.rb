require File.expand_path('../../test_helper', __FILE__)

class GostControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_index
    get :index, project_id: 1

    assert_response :success
    assert_template 'index'
  end
end
