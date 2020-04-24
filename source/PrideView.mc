using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;

class PrideView extends WatchUi.WatchFace {

    // Initialize Class Variables
    var dcR, center, background, font, fontSmall;
    var myStats = System.getSystemStats();

    function initialize() {
        WatchFace.initialize();

        // Initialize Resources
        font = WatchUi.loadResource(Rez.Fonts.font);
        fontSmall = WatchUi.loadResource(Rez.Fonts.fontSmall);
        background = WatchUi.loadResource(Rez.Drawables.flag);
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));

        // Change context and center when layout changes.
        center = [dc.getWidth()/2, dc.getHeight()/2];
        dcR = dc;
    }

    function onUpdate(dc) {
        View.onUpdate(dc);

        // Call each function to make the watchface.
        drawBackground();
        drawTime();
        drawDate();
        drawBattery();
        drawStepCount();
    }

    function drawStepCount(){
        // Make Activity Monitor Object and format the amount of steps.
        var activityInfo = ActivityMonitor.getInfo();
        var stepsString = activityInfo.steps.toString();

        // Draw the labels.
        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.drawText(center[0], center[1]+50, fontSmall, "Steps:", Graphics.TEXT_JUSTIFY_CENTER);
        dcR.drawText(center[0], center[1]+70, fontSmall, stepsString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawBackground(){
        // Draw the pri
        dcR.drawBitmap(-8, -10, background);
        dcR.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dcR.fillCircle(center[0], center[1], center[0]/1.2);
    }

    function checkAMPM(hours){
        var AMPM = "AM";

        // If the amount of hours is above 12 (1PM == 13) it will subtract 12 and change AMPM to PM.
        if(hours > 11){
            hours = hours - 12;
            AMPM = "PM";
        }
        // Checks if the time got set to 0.
        if(hours == 0){
                hours = 12;
        }
        // Returns an array with the corrected hours variable and the correct AMPM string.
        return [hours, AMPM];
    }

    function drawTime(){
        // Gather system time and store it.
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var twelveHour = checkAMPM(today.hour);
        var timeString = Lang.format("$1$:$2$ $3$", [twelveHour[0], today.min.format("%02d"), twelveHour[1]]);

        // Draws time.
        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.drawText(center[0], center[1]-40, font, timeString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawDate(){
        // Gather system date and store it.
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$, $3$", [today.month, today.day, today.year]);

        // Draws the date.
        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.drawText(center[0], center[1]-5, font, dateString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawBattery(){
        var batteryY = center[1] - 75;
        var offset = center[1] - 115;

        // Draw the background for the battery charge indicator.
        dcR.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dcR.fillRectangle(center[0]-15, (batteryY)+offset, 25, 14);
        dcR.fillRectangle(center[0]+4, (batteryY)+offset+3, 9, 8);

        // Draw the rectangle that shows charge.
        dcR.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
        dcR.fillRoundedRectangle(center[0]-14, (batteryY+1)+offset, myStats.battery.format("%02d").toNumber().toDouble()/4-2, 12, 2);
    }

    function onShow() {
    }

    function onHide() {
    }

    function onExitSleep() {
    }

    function onEnterSleep() {
    }
}