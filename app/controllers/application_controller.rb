require 'pry'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  #GET request
  get '/games' do
    #get 10 games, order by title
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  #get game by id
  get '/games/:id' do
    game = Game.find(params[:id])

    #include reviews and user of review with the returned json
    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

  #GET review by id
  get '/reviews/:id' do
    review = Review.find(params[:id])
    review.to_json
  end

  #DELETE requests
  delete '/reviews/:id' do
    # find the review using the ID
    review = Review.find(params[:id])
    # delete the review
    review.destroy
    # send a response with the deleted review as JSON
    review.to_json
  end

  #POST requests
  post '/reviews' do
  review = Review.create(
    score: params[:score],
    comment: params[:comment],
    game_id: params[:game_id],
    user_id: params[:user_id]
  )
  review.to_json
end

#PATCH request
patch '/reviews/:id' do
  #find the review to update
  review = Review.find(params[:id])

  #access the data in the body of the request and use it to update review in db
  review.update(
    score: params[:score],
    comment: params[:comment]
  )

  #This is more abstract and dynamic
  #review.update(params)

  #send response with updated review as JSON
  review.to_json
end

end
