module Handlers
  def_handler FavroDiscord do
# {
#   "payloadId" => "5Z57xAwmY7FHY/adclSAKCn6Yqc=", 
#   "action" => "created", 
#   "sender" => {"userId" => "G8Hgek4MAS3eCyoMu", "name" => "Doug Alcorn", "email" => "doug@gaslight.co"}, 
#   "card" => {
#     "cardId" => "096915086891ce706fd26f2e", 
#     "cardCommonId" => "08c412c169403634c202f1de", 
#     "organizationId" => "265fa40dcaa7dd8ddc1cd312", 
#     "archived" => false, 
#     "position" => 0, 
#     "name" => "Roll our own draw/edit tool", 
#     "widgetCommonId" => "0ab5abffa704c35bff94525f", 
#     "columnId" => "3a81551cfe4a1ef09c2f2fcd",
#     "isLane" => false, 
#     "parentCardId" => nil, 
#     "tags" => ["4846e913a1acf3ac13cecd2f", "ZuKdGRwxpaQxPjcwC"], 
#     "sequentialId" => 335, 
#     "assignments" => [{"userId" => "6WGZmKhdow2qTirfL", "completed" => false}], 
#     "numComments" => 3, 
#     "tasksTotal" => 5, 
#     "tasksDone" => 4, 
#     "attachments" => []
#   }, 
#   "comment" => {
#     "commentId" => "7tqMGyjuWkaa8rdzQ", 
#     "cardCommonId" => "08c412c169403634c202f1de", 
#     "organizationId" => "265fa40dcaa7dd8ddc1cd312", 
#     "userId" => "G8Hgek4MAS3eCyoMu", 
#     "comment" => "testing comment to discord", 
#     "created" => "2017-08-24T18:30:17.387Z"
#   }
# }https://favro.com/card/265fa40dcaa7dd8ddc1cd312/Gas-335

    body = JSON.parse(env.request.body.as(IO).gets_to_end)

    if body["comment"]?
      fields = [{"name" => "#{body["action"]} Comment", "value" => "#{body["comment"]["comment"]}", "inline" => true}]
    elsif body["card"]["detailedDescription"]?
        description = body["card"]["detailedDescription"]
    end

    if body["card"]? && body["sender"]?
    discord_payload = {
     "embeds" => [{
       "title" => body["card"]["name"],
       "url" => "http://favro.com/card/#{body["card"]["organizationId"]}/Gas-#{body["card"]["sequentialId"]}",
       "description" => description,
       "color" => 0x79589f,
       "author" => {
         "name" => "#{body["sender"]["name"]} <#{body["sender"]["email"]}>"
       },
       "fields" => fields,
       "timestamp" => Time.now
     }]
    }
  else
    discord_payload = {"content" => body.to_s}
  end


    # Send the formatted webhook payload to Discord.
    HTTP::Client.post(target.to_s, headers: HTTP::Headers{"Content-Type" => "application/json"}, body: discord_payload.to_json)
  end
end


