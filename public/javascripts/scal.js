/*  Scal - prototype calendar/date picker
 *   - Jamie Grove
 *   - Ian Tyndall
 *
 *  Scal is freely distributable under the terms of an MIT-style license.
 *  For details, see the Scal web site: http://scal.fieldguidetoprogrammers.com
 *
 *--------------------------------------------------------------------------*/
Object.extend(Date.prototype, {
    monthnames: ['January','February','March','April','May','June','July','August','September','October','November','December'],
    daynames: ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],
    succ: function(){
        var sd = new Date(this.getFullYear(),this.getMonth(),this.getDate()+1);
        sd.setHours(this.getHours(),this.getMinutes(),this.getSeconds(),this.getMilliseconds());
        return sd;
    },
    firstofmonth: function(){
        return new Date(this.getFullYear(),this.getMonth(),1);
    },
    lastofmonth: function(){
        return new Date(this.getFullYear(),this.getMonth()+1,0);
    },
    formatPadding: true,
    format: function(f){
        if (!this.valueOf()) { return '&nbsp;'; }
        var d = this;
        var formats = {
            'yyyy' : d.getFullYear(),
            'mmmm': this.monthnames[d.getMonth()],
            'mmm':  this.monthnames[d.getMonth()].substr(0, 3),
            'mm':   this.formatPadding ? ((d.getMonth()).succ()).toPaddedString(2) : (d.getMonth()).succ(),
            'dddd': this.daynames[d.getDay()],
            'ddd':  this.daynames[d.getDay()].substr(0, 3),
            'dd':   d.getDate().toPaddedString(2),
            'hh':   h = d.getHours() % 12 ? h : 12,
            'nn':   d.getMinutes(),
            'ss':   d.getSeconds(),
            'a/p':  d.getHours() < 12 ? 'a' : 'p'
        };
        return f.gsub(/(yyyy|mmmm|mmm|mm|dddd|ddd|dd|hh|nn|ss|a\/p)/i,
            function(match) { return formats[match[0].toLowerCase()]; });
    }
});

var scal = {};
scal = Class.create();
scal.prototype = {
    initialize: function(element,update) {
        this.element = $(element);
        var type = Try.these(
            function(){ if(!Object.isUndefined(Effect)) { return 'Effect'; }},
            function(){ return 'Element'; }
        );  
        this.options = Object.extend({
          oncalchange: Prototype.emptyFunction,
          daypadding: false,
          titleformat: 'mmmm yyyy',
          updateformat: 'yyyy-mm-dd',
          closebutton: 'X',
          prevbutton: '&laquo;',
          nextbutton: '&raquo;',
          yearnext: '&raquo;&raquo;',
          yearprev: '&laquo;&laquo;',
          openeffect: type == 'Effect' ? Effect.Appear : Element.show,
          closeeffect: type == 'Effect' ? Effect.Fade : Element.hide,
          exactweeks: false,
          dayheadlength: 2,
          weekdaystart: 0,
          planner: false,
          tabular: false
        }, arguments[2] || { });   
        this.table = false;
        this.thead = false;
        this.startdate = this._setStartDate(arguments[2]);
        if(this.options.planner) { this._setupPlanner(this.options.planner); }
        if(this.options.tabular) { 
            this.table = new Element('table',{'class': 'cal_table',border: 0,cellspacing: 0,cellpadding: 0});
            this.thead = new Element('thead');
            this.table.insert(this.thead);
            this.element.insert(this.table);
        }
        this.updateelement = update;
        this._setCurrentDate(this.startdate); 
        this.initDate = new Date(this.currentdate);
        this.controls = this._buildControls();
        this.title.setAttribute('title', this.initDate.format(this.options.titleformat));
        this._updateTitles();
        this[this.table ? 'thead' : 'element'].insert(this.controls);
        this.cal_wrapper = this._buildHead();
        this.cells = [];
        this._buildCal();
    },
/*------------------------------- INTERNAL -------------------------------*/    
    _setStartDate: function() {
	var args = arguments[0];
        var startday = new Date();
        this.options.month = args && args.month && Object.isNumber(args.month) ? args.month - 1 : startday.getMonth();
        this.options.year = args && args.year && Object.isNumber(args.year) ? args.year : startday.getFullYear();
        this.options.day = args && args.day && Object.isNumber(args.day) ? args.day : (this.options.month != startday.getMonth()) ? 1 : startday.getDate();
        startday.setHours(0,0,0,0);
        startday.setDate(this.options.day);
        startday.setMonth(this.options.month);
        startday.setFullYear(this.options.year);
        return startday;
    },
    _emptyCells: function() {
        if(this.cells.size() > 0) { 
            this.cells.invoke('stopObserving'); 
            this.cells.invoke('remove');
            this.cells = [];
        }
    },
    _buildCal: function() {
        this._emptyCells();
        if(!(Object.isUndefined(this.cal_weeks_wrapper) || this.table)) { this.cal_weeks_wrapper.remove(); }
        this.cal_weeks_wrapper = this._buildWrapper();
        if(this.table) {
            this.table.select('tbody tr.weekbox:not(.weekboxname)').invoke('remove');
            this.table.select('tbody.cal_wrapper').invoke('remove');
            this.cal_weeks_wrapper.each(function(row){
                this.cal_wrapper.insert(row);
            }.bind(this));
        } else {
            this.cal_wrapper.insert(this.cal_weeks_wrapper);
        }
        this[this.table ? 'table' : 'element'].insert(this.cal_wrapper);
    },
    _click: function(event,cellIndex) {
        this.element.select('.dayselected').invoke('removeClassName', 'dayselected');
        (event.target.hasClassName('daybox') ? event.target : event.target.up()).addClassName('dayselected');
        this._setCurrentDate(this.dateRange[cellIndex]);
        this._updateExternal();
    },
    _updateExternal: function(){	
        if (Object.isFunction(this.updateelement)){
            this.updateelement(this.currentdate);
        } else {	
            var updateElement = $(this.updateelement);
            updateElement[updateElement.tagName == 'INPUT' ? 'setValue' : 'update'](this.currentdate.format(this.options.updateformat));
        }            
    },    
    _buildHead: function() {
        var cal_wrapper = new Element(this.table ? 'tbody' : 'div',{'class':'cal_wrapper'});
        var weekbox = new Element(this.table ? 'tr' : 'div',{'class':'weekbox weekboxname'});
        Date.prototype.daynames.sortBy(function(s,i){
            i-=this.options.weekdaystart;
            if(i<0){i+=7;}
            return i;
        }.bind(this)).each(function(day,i) {
        var cell = new Element(this.table ? 'td' : 'div',{'class':'cal_day_name_'+ i});
        cell.addClassName('daybox').addClassName('dayboxname').update(day.substr(0,this.options.dayheadlength));
        if(i == 6) { cell.addClassName('endweek'); }
        weekbox.insert(cell);
        }.bind(this));
        return cal_wrapper.insert(weekbox);
    },
    _buildWrapper: function() {
        var firstdaycal = new Date(this.firstofmonth.getFullYear(),this.firstofmonth.getMonth(),this.firstofmonth.getDate());
        var lastdaycal = new Date(this.lastofmonth.getFullYear(),this.lastofmonth.getMonth(),this.lastofmonth.getDate());
		if(this.options.weekdaystart-firstdaycal.getDay() < firstdaycal.getDate()){
        firstdaycal.setDate(firstdaycal.getDate() - firstdaycal.getDay() + this.options.weekdaystart);
        } else {
		firstdaycal.setDate(firstdaycal.getDate() - (firstdaycal.getDay() + 7 - this.options.weekdaystart));
		}
        var dateRange = $A($R(firstdaycal,lastdaycal));
        var cal_weeks_wrapper = this.table ? [] : new Element('div',{'class': 'calweekswrapper'});
        var wk;
        var row;
        var lastday;
        this.dateRange = [];
        this.indicators = []; // holds values to determine if continued checking for custom classes is needed
        var buildWeek = function(day) {
            row.insert(this._buildDay(wk, day));
            lastday = day;
        }.bind(this);       
        dateRange.eachSlice(7, function(slice,i) {
            wk = i;
            row = new Element(this.table ? 'tr' : 'div',{'class':'cal_week_' + wk}).addClassName('weekbox');
            while(slice.length < 7) { 
                slice.push(slice.last().succ());
            }
            slice.map(buildWeek);	
            cal_weeks_wrapper[this.table ? 'push' : 'insert'](row);
        }.bind(this));
        if(!this.options.exactweeks) {
            var toFinish = 42 - this.cells.size(); 
            var wkstoFinish = Math.ceil(toFinish / 7);
            if(wkstoFinish > 0) { toFinish = toFinish / wkstoFinish; }
            $R(1,wkstoFinish).each(function(w){
                wk += 1;
                row = new Element(this.table ? 'tr' : 'div',{'class':'cal_week_' + wk}).addClassName('weekbox'); 
                $R(1,toFinish).each(function(i) {
                    var d = lastday.succ();
                    row.insert(this._buildDay(wk, d));
                    cal_weeks_wrapper[this.table ? 'push' : 'insert'](row);
                    lastday = d;
                }.bind(this));
            }.bind(this));
        }	
        return cal_weeks_wrapper;
    },
    _compareDates: function(date1,date2,type){
        return (this.indicators.indexOf(type) >= 0) ? false : Object.isUndefined(['getMonth','getDate','getFullYear'].find(function(n){ return date1[n]() != date2[n](); }));
    },
    _buildDay: function(week,day){
        this.dateRange.push(day);
        var cellid = 'cal_day_' + week + '_' + day.getDay();
        var cell = new Element(this.table ? 'td' : 'div',{'class':cellid});
        var celldate = new Element('div',{'class':cellid+'_date'}).addClassName('dayboxdate').update(this.options.daypadding ? ((day.getDate()).toPaddedString(2)) : day.getDate());
        var cellvalue = new Element('div',{'class':cellid+'_value'}).addClassName('dayboxvalue');
        if(this.options.planner) { this._updatePlanner(day,cellvalue); }
        cell.insert(celldate).insert(cellvalue).addClassName('daybox').addClassName('daybox'+ day.format('dddd').toLowerCase());
        // if we are on the currently selected date, set the class to dayselected (i.e. highlight it).
        if(this._compareDates(day,this.currentdate,'dayselected')) {
            cell.addClassName('dayselected');
            this.indicators.push('dayselected');
        }
        if(this._compareDates(day,new Date(),'today')) {
            cell.addClassName('today');
            this.indicators.push('today');
        }
        if(day.getDay() == 6) { cell.addClassName('endweek'); }
        // if we are outside the current month set the day style to 'deactivated'
        var cs = day.getMonth() != this.currentdate.getMonth() ? ['dayoutmonth','dayinmonth'] : ['dayinmonth','dayoutmonth'];
        cell.addClassName(cs[0]);
        if(cell.hasClassName(cs[1])) { cell.removeClassName(cs[1]); }
        this.cells.push(cell);
        return cell.observe('click', this._click.bindAsEventListener(this, this.cells.size() - 1));
    },
    _updateTitles: function() {
        var yr = this.currentdate.getFullYear();
        var mnth = this.currentdate.getMonth();
        var titles = {
            calprevmonth: Date.prototype.monthnames[(mnth - 1) == -1 ? 11 : mnth - 1],
            calprevyear: yr - 1,
            calnextyear: yr + 1,
            calnextmonth: Date.prototype.monthnames[(mnth + 1) == 12 ? 0 : mnth + 1]
        };
        this.controls.select('.calcontrol').each(function(ctrl) {
           var title = titles[ctrl.className.split(' ')[0]];
           if(!Object.isUndefined(title)) { ctrl.setAttribute('title',title); }
        });
    },
    _buildControls: function() {
        var hParts = [
            {p: 'calclose', u: this.options.closebutton, f:  this.toggleCalendar.bindAsEventListener(this)},
            {p: 'calprevmonth', u: this.options.prevbutton, f: this._switchCal.bindAsEventListener(this,'monthdown')},
            {p: 'calprevyear', u: this.options.yearprev, f: this._switchCal.bindAsEventListener(this,'yeardown')},
            {p: 'calnextyear', u: this.options.yearnext, f: this._switchCal.bindAsEventListener(this,'yearup')},
            {p: 'calnextmonth', u: this.options.nextbutton, f: this._switchCal.bindAsEventListener(this,'monthup')},
            {p: 'caltitle', u: this.currentdate.format(this.options.titleformat), f: this._switchCal.bindAsEventListener(this,'init')}
        ];
        if(this.table) { hParts = [hParts[1],hParts[2],hParts[5],hParts[3],hParts[4],hParts[0]]; }
        var cal_header = new Element(this.table ? 'tr' : 'div',{'class':'calheader'});
        hParts.each(function(part) {
            var el = new Element(this.table ? 'td' : 'div',{'class': part.p});
            if(part.p == 'caltitle') {
                this.title = el;
                if(this.table) { el.writeAttribute({colspan: 2}); }
                el.update(part.u).observe('click',part.f);
            } else {
                el.addClassName('calcontrol');
                el[typeof(part.u) == 'object' ? 'insert' : 'update'](part.u).observe('click',part.f);
            }
            cal_header.insert(el);
        }.bind(this));
        return cal_header;
    },
    _switchCal: function(){
        if(arguments[1]) {
            var event = arguments[0];
            var direction = arguments[1];
            event.date = this.currentdate;
        } else {
            var direction = arguments[0];
        }			
        var params = {f: 'setTime', p: this.initDate.getTime()};
        var sday = this.currentdate.getDate();
        if(direction != 'init') {
            var d = this.currentdate[direction.include('month') ? 'getMonth' : 'getFullYear']();
            params = {f: direction.include('month') ? 'setMonth' : 'setYear', p: direction.include('up') ? d + 1 : d - 1};
        }
        this.currentdate[params.f](params.p);
        if (this.currentdate.getDate() != sday){
            this.currentdate.setDate(0);
        }
        if(arguments[1]) { this.options.oncalchange(event); }
        this._update();
    }, 
    _update: function() {
        this._setCurrentDate(arguments[0] ? arguments[0] : this.currentdate);
        this.title.update(this.currentdate.format(this.options.titleformat));
        this._buildCal();
        this._updateTitles();
    },
    _setCurrentDate: function(date){
        this.currentdate = new Date(date.getFullYear(),date.getMonth(),date.getDate());
        this.firstofmonth = this.currentdate.firstofmonth();
        this.lastofmonth = this.currentdate.lastofmonth();
    },    
    _getCellIndexByDate: function(d) {
        var findDate = d.getTime();
        var cellIndex = 0;
        this.dateRange.each(function(dt,i) {
            if(dt.getTime() == findDate) {
                cellIndex = i;
                throw $break;
            }
        });
        return cellIndex;
    },
/*------------------------------- PUBLIC -------------------------------*/        
    destroy: function(){
        this._emptyCells();
        if(this.table) { 
            this.table.remove();
        } else {
            this.cal_weeks_wrapper.remove();
        }
		this.controls.descendants().invoke('stopObserving');
        [this.cal_wrapper,this.controls].invoke('remove');
    },
    setCurrentDate: function(direction){
        this[(direction instanceof Date) ? '_update' : '_switchCal'](direction);
        if(!arguments[1]) { this._updateExternal(); }
        return this.currentdate; 
    },
    toggleCalendar: function(){
        this.options[this.element.visible() ? 'closeeffect' : 'openeffect'](this.element);
    },
    getElementByDate: function(d) {
        return this.cells[this._getCellIndexByDate(d)];
    },
    getElementsByWeek: function(week) {
        return this.element.select('.weekbox:nth-of-type(' + (week + 1) + ') .daybox:not(.dayboxname)');
    },
    getSelectedElement: function() {
        return this.element.select('.dayselected')[0];
    },
    getTodaysElement: function() {
        return this.element.select('.today')[0];
    },
    getDateByElement: function(element) {
        return this.dateRange[this.cells.indexOf(element)];
    },
/*------------------------------- PLUG-IN PLACEHOLDERS -------------------------------*/            
    _setupPlanner: Prototype.emptyFunction,
    _updatePlanner: Prototype.emptyFunction,
/*------------------------------- DEPRECATED -------------------------------*/            
    openCalendar: function(){ 
        if(!this.isOpen()){ this.toggleCalendar(); }
    },
    closeCalendar: function(){ 
        if(this.isOpen()){ this.toggleCalendar(); }
    },
    isOpen: function(){ 
        return this.element.visible();
    }
};
