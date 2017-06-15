var React = require('react');




var speech = React.createClass({
   startDictation : function() {

    if (window.hasOwnProperty('webkitSpeechRecognition')) {

      var recognition = new webkitSpeechRecognition();

      recognition.continuous = false;
      recognition.interimResults = false;

      recognition.lang = "en-US";
      recognition.start();

      recognition.onresult = function(e) {
        document.getElementById('transcript').value
                                 = e.results[0][0].transcript;
        recognition.stop();
        document.getElementById('labnol').submit();
      };

      recognition.onerror = function(e) {
        recognition.stop();
      }

    }
  },
  render: function() {
    return (
      <div>
        <form id="labnol" method="get" action="https://www.google.com/search">
          <div class="speech">
            <input type="text" name="q" id="transcript" placeholder="Speak" />
            <img onclick={this.startDictation} src="//i.imgur.com/cHidSVu.gif" />

          </div>
        </form>
      </div>
    )
  }
})


module.exports = speech;
