# $(document).on "change", "select", ->
#   console.log $(this).val()
#
$ ->
  Matcha.slides $("#slidesDemo ul"), {
    auto: false
    interval: 3
    effect: "fade"
    pageable: true
    locale:
      prev: "上一个"
      next: "下一个"
  }
