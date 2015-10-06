jQuery ->
  if $('#markdown-textarea').length > 0
    new EpicEditor({
      textarea: 'markdown-textarea'
      autogrow: true
      theme: { preview: '/assets/application.css' }
      clientSideStorage: false
    }).load()
