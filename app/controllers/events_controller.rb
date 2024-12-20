class EventsController < ApplicationController
  def index
    @events = Event.all.order(start_date: :asc)
  end
end
