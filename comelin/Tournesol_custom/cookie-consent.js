(function ()
{


  // ========================================
  // Cookies functions
  // ========================================
  // Fix: Allow to exist with or without jQuery
  if ($ === null || typeof $ !== 'object')
  {
    var $ = new Object;
  }

  // Source: https://stackoverflow.com/a/48521179/3894752
  // Note: This will return false on localhost in Chrome https://stackoverflow.com/a/8225269
  $.areCookiesEnabled = function ()
  {
    try
    {
      // Create cookie
      document.cookie = 'cookietest=1';
      var cookiesEnabled = document.cookie.indexOf('cookietest=') != -1;
      // Delete cookie
      document.cookie = 'cookietest=1; expires=Thu, 01-Jan-1970 00:00:01 GMT';
      return cookiesEnabled;
    } catch (e)
    {
      return false;
    }
  }

  // Source: https://gist.githubusercontent.com/bronson/6707533/raw/7317b0e0d204d00d3b01d06f9f18a09ae4ee6f4e/cookie.js
  // cookie.js
  //
  // Usage:
  //  $.cookie('mine', 'data', 5*60*1000)  -- write data to cookie named mine that lasts for five minutes
  //  $.cookie('mine')                     -- read the cookie that was just set, function result will be 'data'
  //  $.cookie('mine', '', -1)             -- delete the cookie

  $.cookie = function (name, value, ms)
  {
    if (arguments.length < 2)
    {
      // read cookie
      var cookies = document.cookie.split(';')
      for (var i = 0; i < cookies.length; i++)
      {
        var c = cookies[i].replace(/^\s+/, '')
        if (c.indexOf(name + '=') == 0)
        {
          return decodeURIComponent(c.substring(name.length + 1).split('+').join(' '))
        }
      }
      return null
    }

    // write cookie
    var date = new Date()
    date.setTime(date.getTime() + ms)
    document.cookie = name + "=" + encodeURIComponent(value) + (ms ? ";expires=" + date.toGMTString() : '') + ";path=/"
  }


  // ========================================
  // Consent Bar
  // ========================================

  /**
   * Init Cookie Consent Bar (no cookie written yet)
   */
  function initCookieConsentBar()
  {
    // only show a cookie bar however if cookies are allowed at all,
    // otherwise keep »null« as consent level
    if ($.areCookiesEnabled() == false)
    {
      return;
    }

    // set default level
    bar = document.getElementsByClassName('cookie-consent')[0];
    level = bar.dataset.level;
    // dont allow automatic Opt-Ins
    if (level === undefined || level >= 50)
    {
      level = 1;
    }
    // dont store cookie for more than 1 year
    duration = bar.dataset.duration;
    if (duration === undefined || duration > 8760)
    {
      duration = 8;
    }

    $.cookie('cookie-consent', level, duration * 60 * 60 * 1000)

    showCookieConsentBar();
  }

  /**
   * Show Cookie Consent Bar
   */
  function showCookieConsentBar()
  {
    bar = document.getElementsByClassName('cookie-consent')[0];
    button = document.getElementsByClassName('cookie-accept')[0];

    setEventListeners(button);
    bar.style.display = 'block';
  }

  /**
   * Set button actions
   * @return null
   */
  function setEventListeners(button)
  {
    var cookieValue = "granted";

    // dont store cookie for more than 1 year
    var duration = button.dataset.duration;
    if (duration === undefined || duration > 8760)
    {
      duration = 8;
    }

    button.addEventListener('click', function ()
    {


      $.cookie('cookie-consent', cookieValue, duration * 60 * 60 * 1000);
      $.cookie('ad_storage', cookieValue, duration * 60 * 60 * 1000);
      $.cookie('analytics_storage', cookieValue, duration * 60 * 60 * 1000);
      $.cookie('functionality_storage', cookieValue, duration * 60 * 60 * 1000);
      $.cookie('personalization_storage', cookieValue, duration * 60 * 60 * 1000);
      $.cookie('security_storage', cookieValue, duration * 60 * 60 * 1000);

      bar.style.display = 'none';
    });
  }

  document.addEventListener('DOMContentLoaded', function ()
  {
    var currentCookieSelection = $.cookie('cookie-consent');
    console.log(currentCookieSelection);

    // first request ever - show cookie bar and set a default level
    if (currentCookieSelection === null)
    {
      initCookieConsentBar();
    } else if (currentCookieSelection > 0 && currentCookieSelection < 50)
    {
      // Keep showing the cookie bar as long as no explicit agreement (Opt-In)
      // was given yet (level lower than 50)
      showCookieConsentBar();
    }
  });

}());