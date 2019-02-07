require 'HTTParty' 

@auth={username:'un', password: 'pass'}


def response_codes
    response = HTTParty.get('https://api.github.com/orgs/BoomTownROI', basic_auth: @auth)
    url_pattern = /(http[s]?:\/\/)?api\.github\.([^\/\s]+\/)(.*)/
    hash = JSON.parse(response.body)
    arr = hash.values
    urls = arr.select{|e| e =~ url_pattern}
    urls.each do |i| 
      begin
        responses = HTTParty.get("#{i}")
        x = responses.code
        puts "#{i} returned a code of #{x}" 
      rescue URI::InvalidURIError 
        puts "I returned an error for #{i}"
      end
    end
end

response_codes



def get_ids(url)
    response = HTTParty.get(url, basic_auth: @auth)
    arr = JSON.parse(response.body)
    arr.map do |ids|
        ids.select do |key, value|  
            ["id", "name"].include? key 
        end
    end
end  
  urls = ['https://api.github.com/orgs/BoomTownROI/repos', 'https://api.github.com/orgs/BoomTownROI/events', 'https://api.github.com/orgs/BoomTownROI']
  
  result = {}
  urls.each do |url|
    if url == 'https://api.github.com/orgs/BoomTownROI'
      response = HTTParty.get(url, basic_auth: @auth)
      domain_hash = JSON.parse(response.body)
      id = domain_hash["id"]
      result[url] = id
    else
      result[url] = get_ids(url)
    end 

  end

puts result



def date_test
    response = HTTParty.get("https://api.github.com/orgs/BoomTownROI", basic_auth: @auth)
    body = JSON.parse(response.body)
    created = body["created_at"]
    updated = body["updated_at"]
    created_date = DateTime.strptime(created)
    updated_date = DateTime.strptime(updated)
    updated_date > created_date 
end

puts date_test



def repo_comparison
    get_top_object = HTTParty.get('https://api.github.com/orgs/BoomTownROI', @auth)
    get_repos = HTTParty.get('https://api.github.com/orgs/BoomTownROI/repos', @auth)
    
    top_object_array = JSON.parse(get_top_object.body)
    repos_array = JSON.parse(get_repos.body)
    
    top_object_array["public_repos"] > repos_array.count
end

puts repo_comparison