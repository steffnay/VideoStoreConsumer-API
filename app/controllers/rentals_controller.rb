class RentalsController < ApplicationController
  before_action :require_movie, only: [:check_out, :check_in]
  before_action :require_customer, only: [:check_out, :check_in]

  # Added by us!
  def index
    render status: :ok, json: Rental.all.map { |rental_info| get_rental_info_hash(rental_info) }
    # rentals = Rental.all.map do |rental|
    #   {
    #       title: rental.movie.title,
    #       customer_id: rental.customer_id,
    #       name: rental.customer.name,
    #       postal_code: rental.customer.postal_code,
    #       checkout_date: rental.checkout_date,
    #       due_date: rental.due_date
    #   }
    # end
    # render status: :ok, json: rentals
  end

  # TODO: make sure that wave 2 works all the way
  def check_out
    rental = Rental.new(movie: @movie, customer: @customer, due_date: params[:due_date])

    if rental.save
      render status: :ok, json: {due_date: rental.due_date}
    else
      render status: :bad_request, json: { errors: rental.errors.messages }
    end
  end

  def check_in
    rental = Rental.first_outstanding(@movie, @customer)
    unless rental
      return render status: :not_found, json: {
        errors: {
          rental: ["Customer #{@customer.id} does not have #{@movie.title} checked out"]
        }
      }
    end
    rental.returned = true
    if rental.save
      render status: :ok, json: {}
    else
      render status: :bad_request, json: { errors: rental.errors.messages }
    end
  end

  def overdue
    render status: :ok, json: Rental.overdue.map { |rental_info| get_rental_info_hash(rental_info) }
    # rentals = Rental.overdue.map { |rental| get_rental_info_hash(rental_info) }
    # render status: :ok, json: rentals
  end

private
  # TODO: make error payloads arrays
  def require_movie
    @movie = Movie.find_by('lower(title) = ?', params[:title].downcase)
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params[:title]}"] } }
    end
  end

  def require_customer
    @customer = Customer.find_by id: params[:customer_id]
    unless @customer
      render status: :not_found, json: { errors: { customer_id: ["No such customer #{params[:customer_id]}"] } }
    end
  end

  def get_rental_info_hash(rental_info)
    return {
        title: rental_info.movie.title,
        customer_id: rental_info.customer_id,
        name: rental_info.customer.name,
        postal_code: rental_info.customer.postal_code,
        checkout_date: rental_info.checkout_date,
        due_date: rental_info.due_date,
        returned: rental_info.returned
    }
  end
end
