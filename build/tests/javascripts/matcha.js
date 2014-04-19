(function( global, factory ) {

  if ( typeof module === "object" && typeof module.exports === "object" ) {
    module.exports = global.document ?
      factory(global, true) :
      function( w ) {
        if ( !w.document ) {
          throw new Error("Requires a window with a document");
        }
        return factory(w);
      };
  } else {
    factory(global);
  }

}(typeof window !== "undefined" ? window : this, function( window, noGlobal ) {

"use strict";
var LIB_CONFIG, getStorageData, hasOwnProp, hook, needFix, scoreHtml, scoreLevels, setDefaultTab, storage, _H;

LIB_CONFIG = {
  name: "Matcha",
  version: "0.2.0"
};

_H = {};

storage = {

  /*
   * JavaScript 钩子
   *
   * @property   hook
   * @type       {Object}
   */
  hook: {
    tabs: {
      component: "tabs",
      trigger: "tabs-trigger",
      content: "tabs-content"
    }
  }
};


/*
 * 判断某个对象是否有自己的指定属性
 *
 * !!! 不能用 object.hasOwnProperty(prop) 这种方式，低版本 IE 不支持。
 *
 * @private
 * @method   hasOwnProp
 * @return   {Boolean}
 */

hasOwnProp = function(obj, prop) {
  return Object.prototype.hasOwnProperty.call(obj, prop);
};


/*
 * 获取指定钩子
 *
 * @private
 * @method   hook
 * @param    name {String}     Hook's name
 * @param    no_dot {Boolean}  Return class when true, default is selector
 * @return   {String}
 */

hook = function(name, no_dot) {
  return (no_dot === true ? "" : ".") + "js-" + $.camelCase(getStorageData("hook." + name));
};


/*
 * Get data from internal storage
 *
 * @private
 * @method   getStorageData
 * @param    ns_str {String}   Namespace string
 * @return   {String}
 */

getStorageData = function(ns_str) {
  var parts, result;
  parts = ns_str.split(".");
  result = storage;
  $.each(parts, function(idx, part) {
    var rv;
    rv = hasOwnProp(result, part);
    result = result[part];
    return rv;
  });
  return result;
};


/*
 * Whether need to fix IE
 *
 * @private
 * @method   needFix
 * @param    version {Integer}
 * @return   {Boolean}
 */

needFix = function(version) {
  return $.browser.msie && $.browser.version * 1 < version;
};


/*
 * Construct HTML string for score
 *
 * @private
 * @method   scoreHtml
 * @param    data {Object}
 * @return   {String}
 */

scoreHtml = function(data) {
  var id, score;
  score = data.score;
  id = "" + data.name + "-" + score;
  return "<input id=\"" + id + "\" class=\"Score-storage Score-storage-" + score + "\" type=\"radio\" name=\"" + data.name + "\" value=\"" + score + "\">\n<a class=\"Score-level Score-level-" + score + "\" href=\"http://www.baidu.com/\">\n  <label for=\"" + id + "\">" + score + "</label>\n</a>";
};

$(document).on("click", ".js-trigger--tab", function() {
  var tabs, trigger;
  trigger = $(this);
  tabs = trigger.closest(".Tabs");
  $(".Tabs-trigger.is-selected, .Tabs-content.is-selected", tabs).removeClass("is-selected");
  $(".Tabs-content[data-flag='" + (trigger.data("flag")) + "']", tabs).add(trigger).addClass("is-selected");
  return false;
});

$(document).on("click", ".js-trigger--score", function() {
  var cls, t;
  t = $(this);
  cls = "is-selected";
  t.siblings("." + cls).removeClass(cls);
  t.addClass(cls);
  t.siblings("[checked]").attr("checked", false);
  t.prev(":radio").attr("checked", true);
  return false;
});

setDefaultTab = function() {
  $(".Tabs[data-setdefault!='false'] > .Tabs-triggers").each(function() {
    var group, selector;
    group = $(this);
    selector = ".Tabs-trigger";
    if ($("" + selector + ".is-selected", group).size() === 0) {
      return $("" + selector + ":first", group).trigger("click");
    }
  });
  return $(".Tabs-trigger.is-selected").trigger("click");
};

scoreLevels = function() {
  $(".Score--selectable[data-highest]").each(function() {
    var data, highest, lowest, __e;
    __e = $(this);
    highest = Number(__e.data("highest"));
    lowest = 1;
    data = {};
    __e.width(highest * 16);
    data.name = __e.data("name") || ("Score-" + ($(".Score--selectable").index(__e) + 1));
    if (isNaN(highest)) {
      highest = 0;
    } else {
      highest += 1;
    }
    while (lowest < highest) {
      data.score = lowest++;
      __e.append(scoreHtml(data));
    }
    return true;
  });
  if (needFix(9)) {
    return $(".Score--selectable .Score-level").addClass("js-trigger--score");
  }
};

$(function() {
  setDefaultTab();
  return scoreLevels();
});

window[LIB_CONFIG.name] = _H;

}));
