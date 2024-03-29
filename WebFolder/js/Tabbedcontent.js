;(function($,document,window,undefined){"use strict";var Tabbedcontent=function(tabcontent,options){var defaults={links:tabcontent.prev().find('a').length?tabcontent.prev().find('a'):'.tabs a',errorSelector:'.error-message',speed:false,onSwitch:false,onInit:false,currentClass:'active',tabErrorClass:'has-errors',history:true,historyOnInit:true,loop:false},firstTime=false,children=tabcontent.children(),history=window.history,loc=document.location,current=null;options=$.extend(defaults,options);if(!(options.links instanceof $)){options.links=$(options.links);}
function tabExists(tab){return Boolean(children.filter(tab).length);}
function isFirst(){return current===0;}
function isInt(num){return num%1===0;}
function isLast(){return current===children.length-1;}
function filterTab(tab){return $(this).attr('href').match(new RegExp(tab+'$'));}
function getTab(tab){if(tab instanceof $){return{tab:tab,link:options.links.eq(tab.index())};}
if(isInt(tab)){return{tab:children.eq(tab),link:options.links.eq(tab)};}
if(children.filter(tab).length){return{tab:children.filter(tab),link:options.links.filter(function(){return filterTab.apply(this,[tab]);})};}
return{tab:children.filter('#'+tab),link:options.links.filter(function(){return filterTab.apply(this,['#'+tab]);})};}
function getCurrent(){return options.links.parent().filter('.'+options.currentClass).index();}
function next(loop){++current;if(loop===undefined)loop=options.loop;if(current<children.length){return switchTab(current,true);}else if(loop&&current>=children.length){return switchTab(0,true);}
return false;}
function prev(loop){--current;if(loop===undefined)loop=options.loop;if(current>=0){return switchTab(current,true);}else if(loop&&current<0){return switchTab(children.length-1,true);}
return false;}
function onSwitch(tab){if(options.history&&options.historyOnInit&&firstTime&&history!==undefined&&('pushState'in history)){firstTime=false;window.setTimeout(function(){history.replaceState(null,'',tab);},100);}
current=getCurrent();if(options.onSwitch&&typeof options.onSwitch==='function'){options.onSwitch(tab,api());}
tabcontent.trigger('tabcontent.switch',[tab,api()]);}
function switchTab(tab,api){if(!tab.toString().match(/^#/)){tab='#'+getTab(tab).tab.attr('id');}
if(!tabExists(tab)){return false;}
options.links.attr('aria-selected','false').parent().removeClass(options.currentClass);options.links.filter(function(){return filterTab.apply(this,[tab]);}).attr('aria-selected','true').parent().addClass(options.currentClass);children.hide();if(options.history&&api){if(history!==undefined&&('pushState'in history)){history.pushState(null,'',tab);}else{window.location.hash=tab;}}
children.attr('aria-hidden','true').filter(tab).show(options.speed,function(){if(options.speed){onSwitch(tab);}}).attr('aria-hidden','false');if(!options.speed){onSwitch(tab);}
return true;}
function apiSwitch(tab){return switchTab(tab,true);}
function hashSwitch(e){switchTab(loc.hash);}
function init(){if(tabExists(loc.hash)){switchTab(loc.hash);}
else if(options.links.parent().filter('.'+options.currentClass).length){switchTab(options.links.parent().filter('.'+options.currentClass).index());}
else if(options.errorSelector&&children.find(options.errorSelector).length){children.each(function(){if($(this).find(options.errorSelector).length){switchTab("#"+$(this).attr("id"));return false;}});}
else{switchTab("#"+children.filter(":first-child").attr("id"));}
if(options.errorSelector){children.find(options.errorSelector).each(function(){var tab=getTab($(this).parent());tab.link.parent().addClass(options.tabErrorClass);});}
if('onhashchange'in window){$(window).bind('hashchange',hashSwitch);}else{var current_href=loc.href;window.setInterval(function(){if(current_href!==loc.href){hashSwitch.call(window.event);current_href=loc.href;}},100);}
$(options.links).on('click',function(e){switchTab($(this).attr('href').replace(/^[^#]+/,''),options.history);e.preventDefault();});if(options.onInit&&typeof options.onInit==='function'){options.onInit(api());}
tabcontent.trigger('tabcontent.init',[api()]);}
function api(){return{'switch':apiSwitch,'switchTab':apiSwitch,'getCurrent':getCurrent,'getTab':getTab,'next':next,'prev':prev,'isFirst':isFirst,'isLast':isLast};}
init();return api();};$.fn.tabbedContent=function(options){return this.each(function(){var tabs=new Tabbedcontent($(this),options);$(this).data('api',tabs);});};})(window.jQuery||window.Zepto||window.$,document,window);
