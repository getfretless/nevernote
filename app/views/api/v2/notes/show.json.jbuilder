json.note do
  json.id         @note.id
  json.title      @note.title
  json.body_html  @note.body_html
  json.body_text  @note.body_text
  json.created_at @note.created_at
  json.updated_at @note.updated_at
  json.user       @note.user.username
end
