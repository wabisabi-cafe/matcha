"use strict"

# Config of library
LIB_CONFIG =
  name: "@NAME"
  version: "@VERSION"

# Main objects
_H = {}

# 内部数据载体
storage =
  ###
  # JavaScript 钩子
  #
  # @property   hook
  # @type       {Object}
  ###
  hook:
    tabs:
      component: "tabs"
      trigger: "trigger--tab"
      content: "tabs-content"
    score:
      trigger: "trigger--score"

###
# 判断某个对象是否有自己的指定属性
#
# !!! 不能用 object.hasOwnProperty(prop) 这种方式，低版本 IE 不支持。
#
# @private
# @method   hasOwnProp
# @return   {Boolean}
###
hasOwnProp = ( obj, prop ) ->
  return Object.prototype.hasOwnProperty.call obj, prop

###
# 获取指定钩子
#
# @private
# @method   hook
# @param    name {String}     Hook's name
# @param    no_dot {Boolean}  Return class when true, default is selector
# @return   {String}
###
hook = ( name, no_dot ) ->
  return (if no_dot is true then "" else ".") + "js-" + getStorageData("hook.#{name}")

###
# Get data from internal storage
#
# @private
# @method   getStorageData
# @param    ns_str {String}   Namespace string
# @return   {String}
###
getStorageData = ( ns_str ) ->
  parts = ns_str.split "."
  result = storage

  $.each parts, ( idx, part ) ->
    rv = hasOwnProp(result, part)
    result = result[part]
    return rv

  return result

###
# Whether need to fix IE
#
# @private
# @method   needFix
# @param    version {Integer}
# @return   {Boolean}
###
needFix = ( version ) ->
  return $.browser.msie and $.browser.version * 1 < version      

###
# Construct HTML string for score
#
# @private
# @method   scoreHtml
# @param    data {Object}
# @return   {String}
###
scoreHtml = ( data ) ->
  score = data.score
  id = "#{data.name}-#{score}"

  return  """
          <input id="#{id}" class="Score-storage Score-storage-#{score}" type="radio" name="#{data.name}" value="#{score}">
          <a class="Score-level Score-level-#{score}" href="http://www.baidu.com/">
            <label for="#{id}">#{score}</label>
          </a>
          """

# Tabs
$(document).on "click", hook("tabs.trigger"), ->
  trigger = $(this)
  tabs = trigger.closest ".Tabs"

  $(".Tabs-trigger.is-selected, .Tabs-content.is-selected", tabs).removeClass "is-selected"
  $(".Tabs-content[data-flag='#{trigger.data "flag"}']", tabs)
    .add trigger
    .addClass "is-selected"

  return false

# Scores / Levels of evaluation
$(document).on "click", hook("score.trigger"), ->
  t = $(this)
  cls = "is-selected"

  t.siblings(".#{cls}").removeClass(cls)
  t.addClass cls

  t.siblings("[checked]").attr("checked", false)
  t.prev(":radio").attr("checked", true)

  return false

# Set a default tab
setDefaultTab = ->
  $(".Tabs[data-setdefault!='false'] > .Tabs-triggers").each ->
    group = $(this)
    selector = ".Tabs-trigger"

    if $("#{selector}.is-selected", group).size() is 0
      $("#{selector}:first", group).trigger "click"

  $(".Tabs-trigger.is-selected").trigger "click"

# Construct levels of evaluation
scoreLevels = ->
  $(".Score--selectable[data-highest]").each ->
    __e = $(this)

    highest = Number __e.data("highest")
    lowest = 1
    data = {}

    __e.width highest * 16

    data.name = __e.data("name") || "Score-#{$(".Score--selectable").index(__e) + 1}"

    if isNaN highest
      highest = 0
    else
      highest += 1

    while lowest < highest
      data.score = lowest++
      __e.append scoreHtml data

    return true

  $(".Score--selectable .Score-level").addClass(hook("score.trigger", true)) if needFix(9)

$ ->
  setDefaultTab()
  scoreLevels()
window[LIB_CONFIG.name] = _H
