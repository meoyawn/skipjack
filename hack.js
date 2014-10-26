function gettimeofday(tv, tz) {
    var now = Date.now();
    tv.tv_sec = now / 1000;
    tv.tv_usec = now * 1000;
    return 0;
}