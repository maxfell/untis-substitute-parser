require 'nokogiri'
require 'open-uri'
require 'json'

def get_modified(site_url)
  return Time.parse(open(site_url).meta["last-modified"])
end

def get_plan(site_url)
  
  meta = {}
  substitutes = {}
  plan = {}
  
  site = Nokogiri::HTML(open(site_url),)

  plan_date = site.at_css(".mon_title").text().scan(/(.*) .*, Woche (.)/)[0]

  meta[:valid_on] = Time.parse(plan_date[0].to_s)
  meta[:week] = plan_date[1] #week A/week B
  meta[:modified] = get_modified(site_url)
  meta[:info] = site.css("table.info tr")[1].text() rescue nil
  meta[:fetched] = Time.now

  site.css('table.mon_list tr:not(:first-child)').each do |row|
    row_data = row.css("td")
  
    unless row_data[0].text() == " " then #Filter out Pausenaufsicht and
      
      form = row_data[0].text()
          
      unless substitutes.has_key?(form) then
        substitutes[form] = Array.new
      end
      
      #puts row_data
    
      substitutes[form].push({
        :period => row_data[1].text()[0].to_i,
        :type => row_data[7].text(),
        :text => row_data[8].text(),
        :was => {
          :teacher => row_data[2].text(),
          :shorthand => row_data[3].text(),
          #:room => row_data[4].text()
          },
        :is => {
          :teacher => row_data[4].text(),
          :shorthand => row_data[5].text(),
          :room => row_data[6].text()}
        })
      end
  end
  
  plan[:meta] = meta
  plan[:substitutes] = substitutes
  
  return plan
  
end