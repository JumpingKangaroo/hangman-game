require 'sinatra'
require 'sinatra/reloader'

def startup(word)
  session[:lives] = 7
  session[:word] = word
  session[:word_length] = session[:word].length
  session[:current_word] = "_" * word.length
  session[:guesses] = []
end

def process_guess(guess)
  correct_guess = false
  session[:word].length.times do |i|
    if session[:word][i] == guess 
      session[:current_word][i] = guess
    else
      if session[:guesses].index(guess) == nil 
        session[:guesses] << guess 
        session[:lives] -= 1
      end
    end
  end
end

configure do
  enable :sessions
  set :session_secret, "secret"
end

get '/' do
  redirect '/restart' if params[:restart] == "Restart" || session[:lives] == nil 
  process_guess(params[:guess]) if params[:guess] != nil
  erb :index, :locals => 
    { :lives => session[:lives], 
      :word_length => session[:word_length],
      :current_word => session[:current_word],
      :guesses => session[:guesses]
       }
end

get '/restart' do
  puts "restarting"
  startup("testing")
  redirect '/'
end
