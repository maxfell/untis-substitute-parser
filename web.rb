load File.dirname(__FILE__) + "/parser.rb"

require 'yaml'
require 'sinatra'

urls = YAML.load_file(File.dirname(__FILE__) + '/config/urls.yml')

#pp get_plan(urls['monday'])
#pp get_modified(urls['monday'])

before ('/:day.*' || '/:day/*') do
  content_type :json, 'charset' => 'utf-8'

  if urls[params[:day]] == nil then
    
    error = {
      :success => false,
      :general_message => "No day '#{params[:day]}' was found.",
      :errors => {
        :day => "Must be 'monday', 'tuesday', 'wednesday', 'thursday, or 'friday'."
      }
    }
    
     halt 404, error.to_json
   end
 
end

get '/' do
  
  redirect "/#{Time.now.strftime("%A").downcase}.json"
  
end

get '/:day.json/modified' do

  return get_modified(urls[params[:day]]).to_s

end

get '/:day.json' do

  callback = params.delete('callback') # jsonp
  #json = get_plan(urls[params[:day]]).to_json

  if params[:filter]
    filter = params[:filter].split(",")
    plan = get_plan(urls[params[:day]])
    plan[:substitutes] = plan[:substitutes].reject { |key,_| !filter.include? key }
    json = plan.to_json
  else
    json = get_plan(urls[params[:day]]).to_json
  end
  

  if callback
    content_type :js
    response = "#{callback}(#{json})" 
  else
    content_type :json
    response = json
  end

  return response

end