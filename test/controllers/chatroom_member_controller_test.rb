require "test_helper"

class ChatroomMemberControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get chatroom_member_create_url
    assert_response :success
  end
end
