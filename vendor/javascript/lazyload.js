var t="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var e={};(function(t,r){e=r(t)})("undefined"!==typeof t?t:e.window||e.global,(function(e){const r={src:"data-src",srcset:"data-srcset",selector:".lazyload",root:null,rootMargin:"0px",threshold:0};const extend=function(){let t={};let e=false;let r=0;let s=arguments.length;if("[object Boolean]"===Object.prototype.toString.call(arguments[0])){e=arguments[0];r++}let merge=function(r){for(let s in r)Object.prototype.hasOwnProperty.call(r,s)&&(e&&"[object Object]"===Object.prototype.toString.call(r[s])?t[s]=extend(true,t[s],r[s]):t[s]=r[s])};for(;r<s;r++){let t=arguments[r];merge(t)}return t};function LazyLoad(e,s){(this||t).settings=extend(r,s||{});(this||t).images=e||document.querySelectorAll((this||t).settings.selector);(this||t).observer=null;this.init()}LazyLoad.prototype={init:function(){if(!e.IntersectionObserver){this.loadImages();return}let r=this||t;let s={root:(this||t).settings.root,rootMargin:(this||t).settings.rootMargin,threshold:[(this||t).settings.threshold]};(this||t).observer=new IntersectionObserver((function(t){Array.prototype.forEach.call(t,(function(t){if(t.isIntersecting){r.observer.unobserve(t.target);let e=t.target.getAttribute(r.settings.src);let s=t.target.getAttribute(r.settings.srcset);if("img"===t.target.tagName.toLowerCase()){e&&(t.target.src=e);s&&(t.target.srcset=s)}else t.target.style.backgroundImage="url("+e+")"}}))}),s);Array.prototype.forEach.call((this||t).images,(function(t){r.observer.observe(t)}))},loadAndDestroy:function(){if((this||t).settings){this.loadImages();this.destroy()}},loadImages:function(){if(!(this||t).settings)return;let e=this||t;Array.prototype.forEach.call((this||t).images,(function(t){let r=t.getAttribute(e.settings.src);let s=t.getAttribute(e.settings.srcset);if("img"===t.tagName.toLowerCase()){r&&(t.src=r);s&&(t.srcset=s)}else t.style.backgroundImage="url('"+r+"')"}))},destroy:function(){if((this||t).settings){(this||t).observer.disconnect();(this||t).settings=null}}};e.lazyload=function(t,e){return new LazyLoad(t,e)};if(e.jQuery){const r=e.jQuery;r.fn.lazyload=function(e){e=e||{};e.attribute=e.attribute||"data-src";new LazyLoad(r.makeArray(this||t),e);return this||t}}return LazyLoad}));var r=e;export default r;

