require "test_helper"

class JobApplicatiionControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get job_applicatiion_create_url
    assert_response :success
  end

  test "should get update" do
    get job_applicatiion_update_url
    assert_response :success
  end
end
