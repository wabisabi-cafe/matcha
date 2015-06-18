do ( _H ) ->
  defaults =
    # 目标元素（jQuery 对象）
    $el: null
    # 方向，0 代表上一个，1 代表下一个
    dir: 1
    # 动态效果，值可为 "fade"、"slide"，其他值时无效果
    effect: "fade"
    # 自动播放
    auto: false
    # 自动播放的时间间隔，以秒为单位
    interval: 5
    # 是否分页
    pageable: false

  # 初始化单个 slides
  initSlides = ( $el, opts ) ->
    effect = opts.effect

    $el
      .addClass "Slides"
      .data dataFlag("SlidesEffect"), effect
      .children "li"
      .addClass "Slides-unit"
      .eq 0
      .addClass "is-active"

    # 可分页
    if opts.pageable is true
    else

    # 自动切换
    if opts.auto is true
      autoSlide $el, (if $.isNumeric(opts.interval) then opts.interval else defaults.interval) * 1000, effect
    else
      $el.parent().append "<div class=\"Slides-triggers\">#{triggerHtml("prev")}#{triggerHtml("next")}</div>"

  # 自动切换
  autoSlide = ( slides, interval, effect ) ->
    setTimeout ->
      changeUnit slides, 1, effect, ->
        autoSlide slides, interval, effect
    , interval

  # 获取 trigger 的 HTML
  triggerHtml = ( dir, text = "" ) ->
    return "<button type=\"button\" class=\"Slides-trigger\" data-direction=\"#{dir}\">#{text}</button>"

  changeUnit = ( slides, dir, effect, callback ) ->
    currCls = "is-active"
    nextCls = "is-next"

    curr = slides.children "li.#{currCls}"

    # 上翻
    if dir is 0
      if curr.is(":first-child")
        next = slides.children "li:last-child"
      else
        next = curr.prev()
    # 下翻
    else
      if curr.is(":last-child")
        next = slides.children "li:first-child"
      else
        next = curr.next()

    handler = ->
      next
        .removeClass nextCls
        .addClass currCls

      curr
        .removeClass currCls
        .show()

      callback?()

    next.addClass nextCls

    # 淡出效果
    if effect is "fade"
      curr.fadeOut handler
    # 无动态效果
    else
      handler()

  _H.addComponent "slides", ( $el, settings = {} ) ->
    if $.isPlainObject($el)
      settings = $el
      $el = settings.$el
    else
      settings.$el = $el

    $el
      .wrap "<div class=\"Slides-wrapper\" />"
      .each ->
        initSlides $(@), $.extend true, {}, defaults, settings

  $(document).on "click", ".Slides-trigger", ->
    slides = $(@).closest(".Slides-wrapper").children ".Slides"

    changeUnit slides, (if $(@).attr("data-direction") is "prev" then 0 else 1), slides.data(dataFlag("SlidesEffect"))

    return false
