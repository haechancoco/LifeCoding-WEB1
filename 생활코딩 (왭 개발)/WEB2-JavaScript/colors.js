
var Links = {
    setColor:function(color) {
        // var alist = document.querySelectorAll('a');
        // var i = 0;
        // while( i<alist.length ) {
        //     alist[i].style.color = color;
        //     i = i + 1;
        // }
        $('a').css('color', color);
    }
}
var Body = {
    setColor:function(color) {
        // document.querySelector('body').style.color
        // = color;
        $('body').css('color', color);
    },
    setBackgroundColor:function(color) {
        // document.querySelector('body').style.
        // backgroundColor = color;
        $('body').css('backgroundColor', color);
    }
}


function NightDayHandler(self) {
    var target = document.querySelector('body');
    if(self.value === 'night') {
        Body.setColor('white');
        Body.setBackgroundColor('black');
        self.value = 'day';

        Links.setColor('powderblue');
    } else {
        Body.setColor('black');
        Body.setBackgroundColor('white');
        self.value = 'night';
        Links.setColor('blue');
    }
}

