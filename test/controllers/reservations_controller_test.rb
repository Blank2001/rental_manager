require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = reservations(:one)
  end

  test "should get index" do
    get reservations_url
    assert_response :success
  end

  test "should get new" do
    get new_reservation_url
    assert_response :success
  end

  test "should create reservation" do
    assert_difference("Reservation.count") do
      post reservations_url, params: { reservation: { collection_date: @reservation.collection_date, collection_location: @reservation.collection_location, cost: @reservation.cost, customer_id: @reservation.customer_id, return_date: @reservation.return_date, return_location: @reservation.return_location, status: @reservation.status, vehicle_id: @reservation.vehicle_id } }
    end

    assert_redirected_to reservation_url(Reservation.last)
  end

  test "should show reservation" do
    get reservation_url(@reservation)
    assert_response :success
  end

  test "should get edit" do
    get edit_reservation_url(@reservation)
    assert_response :success
  end

  test "should update reservation" do
    patch reservation_url(@reservation), params: { reservation: { collection_date: @reservation.collection_date, collection_location: @reservation.collection_location, cost: @reservation.cost, customer_id: @reservation.customer_id, return_date: @reservation.return_date, return_location: @reservation.return_location, status: @reservation.status, vehicle_id: @reservation.vehicle_id } }
    assert_redirected_to reservation_url(@reservation)
  end

  test "should destroy reservation" do
    assert_difference("Reservation.count", -1) do
      delete reservation_url(@reservation)
    end

    assert_redirected_to reservations_url
  end
end
