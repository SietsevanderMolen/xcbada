with Interfaces.C; use Interfaces.C;
with bits_types_h;
with Interfaces.C.Strings;
with stddef_h;
with System;
with xlocale_h;
with sys_types_h;

package time_h is

  -- Copyright (C) 1991-2012 Free Software Foundation, Inc.
  --   This file is part of the GNU C Library.
  --   The GNU C Library is free software; you can redistribute it and/or
  --   modify it under the terms of the GNU Lesser General Public
  --   License as published by the Free Software Foundation; either
  --   version 2.1 of the License, or (at your option) any later version.
  --   The GNU C Library is distributed in the hope that it will be useful,
  --   but WITHOUT ANY WARRANTY; without even the implied warranty of
  --   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  --   Lesser General Public License for more details.
  --   You should have received a copy of the GNU Lesser General Public
  --   License along with the GNU C Library; if not, see
  --   <http://www.gnu.org/licenses/>.   

  -- *	ISO C99 Standard: 7.23 Date and time	<time.h>
  --  

  -- Get size_t and NULL from <stddef.h>.   
  -- This defines CLOCKS_PER_SEC, which is the number of processor clock
  --   ticks per second.   

  -- This is the obsolete POSIX.1-1988 name for the same constant.   
  -- Returned by `clock'.   
   subtype clock_t is bits_types_h.uu_clock_t;  -- /usr/include/time.h:59

  -- Returned by `time'.   
   subtype time_t is bits_types_h.uu_time_t;  -- /usr/include/time.h:75

  -- Clock ID used in clock and timer functions.   
   subtype clockid_t is bits_types_h.uu_clockid_t;  -- /usr/include/time.h:91

  -- Timer ID returned by `timer_create'.   
   subtype timer_t is bits_types_h.uu_timer_t;  -- /usr/include/time.h:103

  -- This defines __time_t for us.   
  -- POSIX.1b structure for a time value.  This is like a `struct timeval' but
  --   has nanoseconds instead of microseconds.   

  -- Seconds.   
   type timespec is record
      tv_sec : aliased bits_types_h.uu_time_t;  -- /usr/include/time.h:122
      tv_nsec : aliased bits_types_h.uu_syscall_slong_t;  -- /usr/include/time.h:123
   end record;
   pragma Convention (C_Pass_By_Copy, timespec);  -- /usr/include/time.h:120

  -- Nanoseconds.   
  -- Used by other time functions.   
  -- Seconds.	[0-60] (1 leap second)  
   type tm is record
      tm_sec : aliased int;  -- /usr/include/time.h:135
      tm_min : aliased int;  -- /usr/include/time.h:136
      tm_hour : aliased int;  -- /usr/include/time.h:137
      tm_mday : aliased int;  -- /usr/include/time.h:138
      tm_mon : aliased int;  -- /usr/include/time.h:139
      tm_year : aliased int;  -- /usr/include/time.h:140
      tm_wday : aliased int;  -- /usr/include/time.h:141
      tm_yday : aliased int;  -- /usr/include/time.h:142
      tm_isdst : aliased int;  -- /usr/include/time.h:143
      tm_gmtoff : aliased long;  -- /usr/include/time.h:146
      tm_zone : Interfaces.C.Strings.chars_ptr;  -- /usr/include/time.h:147
   end record;
   pragma Convention (C_Pass_By_Copy, tm);  -- /usr/include/time.h:133

  -- Minutes.	[0-59]  
  -- Hours.	[0-23]  
  -- Day.		[1-31]  
  -- Month.	[0-11]  
  -- Year	- 1900.   
  -- Day of week.	[0-6]  
  -- Days in year.[0-365]	 
  -- DST.		[-1/0/1] 
  -- Seconds east of UTC.   
  -- Timezone abbreviation.   
  -- Seconds east of UTC.   
  -- Timezone abbreviation.   
  -- POSIX.1b structure for timer start values and intervals.   
   type itimerspec is record
      it_interval : aliased timespec;  -- /usr/include/time.h:163
      it_value : aliased timespec;  -- /usr/include/time.h:164
   end record;
   pragma Convention (C_Pass_By_Copy, itimerspec);  -- /usr/include/time.h:161

  -- We can use a simple forward declaration.   
   --  skipped empty struct sigevent

  -- Time base values for timespec_get.   
  -- Time used by the program so far (user time + system time).
  --   The result / CLOCKS_PER_SECOND is program time in seconds.   

   function clock return clock_t;  -- /usr/include/time.h:189
   pragma Import (C, clock, "clock");

  -- Return the current time and put it in *TIMER if TIMER is not NULL.   
   function time (arg1 : access time_t) return time_t;  -- /usr/include/time.h:192
   pragma Import (C, time, "time");

  -- Return the difference between TIME1 and TIME0.   
   function difftime (arg1 : time_t; arg2 : time_t) return double;  -- /usr/include/time.h:195
   pragma Import (C, difftime, "difftime");

  -- Return the `time_t' representation of TP and normalize TP.   
   function mktime (arg1 : access tm) return time_t;  -- /usr/include/time.h:199
   pragma Import (C, mktime, "mktime");

  -- Format TP into S according to FORMAT.
  --   Write no more than MAXSIZE characters and return the number
  --   of characters written, or 0 if it would exceed MAXSIZE.   

   function strftime
     (arg1 : Interfaces.C.Strings.chars_ptr;
      arg2 : stddef_h.size_t;
      arg3 : Interfaces.C.Strings.chars_ptr;
      arg4 : System.Address) return stddef_h.size_t;  -- /usr/include/time.h:205
   pragma Import (C, strftime, "strftime");

  -- Parse S according to FORMAT and store binary time information in TP.
  --   The return value is a pointer to the first unparsed character in S.   

  -- Similar to the two functions above but take the information from
  --   the provided locale and not the global locale.   

   function strftime_l
     (arg1 : Interfaces.C.Strings.chars_ptr;
      arg2 : stddef_h.size_t;
      arg3 : Interfaces.C.Strings.chars_ptr;
      arg4 : System.Address;
      arg5 : xlocale_h.uu_locale_t) return stddef_h.size_t;  -- /usr/include/time.h:223
   pragma Import (C, strftime_l, "strftime_l");

  -- Return the `struct tm' representation of *TIMER
  --   in Universal Coordinated Time (aka Greenwich Mean Time).   

   function gmtime (arg1 : access time_t) return access tm;  -- /usr/include/time.h:239
   pragma Import (C, gmtime, "gmtime");

  -- Return the `struct tm' representation
  --   of *TIMER in the local timezone.   

   function localtime (arg1 : access time_t) return access tm;  -- /usr/include/time.h:243
   pragma Import (C, localtime, "localtime");

  -- Return the `struct tm' representation of *TIMER in UTC,
  --   using *TP to store the result.   

   function gmtime_r (arg1 : access time_t; arg2 : access tm) return access tm;  -- /usr/include/time.h:249
   pragma Import (C, gmtime_r, "gmtime_r");

  -- Return the `struct tm' representation of *TIMER in local time,
  --   using *TP to store the result.   

   function localtime_r (arg1 : access time_t; arg2 : access tm) return access tm;  -- /usr/include/time.h:254
   pragma Import (C, localtime_r, "localtime_r");

  -- Return a string of the form "Day Mon dd hh:mm:ss yyyy\n"
  --   that is the representation of TP in this format.   

   function asctime (arg1 : System.Address) return Interfaces.C.Strings.chars_ptr;  -- /usr/include/time.h:261
   pragma Import (C, asctime, "asctime");

  -- Equivalent to `asctime (localtime (timer))'.   
   function ctime (arg1 : access time_t) return Interfaces.C.Strings.chars_ptr;  -- /usr/include/time.h:264
   pragma Import (C, ctime, "ctime");

  -- Reentrant versions of the above functions.   
  -- Return in BUF a string of the form "Day Mon dd hh:mm:ss yyyy\n"
  --   that is the representation of TP in this format.   

   function asctime_r (arg1 : System.Address; arg2 : Interfaces.C.Strings.chars_ptr) return Interfaces.C.Strings.chars_ptr;  -- /usr/include/time.h:272
   pragma Import (C, asctime_r, "asctime_r");

  -- Equivalent to `asctime_r (localtime_r (timer, *TMP*), buf)'.   
   function ctime_r (arg1 : access time_t; arg2 : Interfaces.C.Strings.chars_ptr) return Interfaces.C.Strings.chars_ptr;  -- /usr/include/time.h:276
   pragma Import (C, ctime_r, "ctime_r");

  -- Defined in localtime.c.   
  -- Current timezone names.   
  -- If daylight-saving time is ever in use.   
  -- Seconds west of UTC.   
  -- Same as above.   
   tzname : aliased array (0 .. 1) of Interfaces.C.Strings.chars_ptr;  -- /usr/include/time.h:289
   pragma Import (C, tzname, "tzname");

  -- Set time conversion information from the TZ environment variable.
  --   If TZ is not defined, a locale-dependent default is used.   

   procedure tzset;  -- /usr/include/time.h:293
   pragma Import (C, tzset, "tzset");

   daylight : aliased int;  -- /usr/include/time.h:297
   pragma Import (C, daylight, "daylight");

   timezone : aliased long;  -- /usr/include/time.h:298
   pragma Import (C, timezone, "timezone");

  -- Set the system time to *WHEN.
  --   This call is restricted to the superuser.   

   function stime (arg1 : access time_t) return int;  -- /usr/include/time.h:304
   pragma Import (C, stime, "stime");

  -- Nonzero if YEAR is a leap year (every 4 years,
  --   except every 100th isn't, and every 400th is).   

  -- Miscellaneous functions many Unices inherited from the public domain
  --   localtime package.  These are included only for compatibility.   

  -- Like `mktime', but for TP represents Universal Time, not local time.   
   function timegm (arg1 : access tm) return time_t;  -- /usr/include/time.h:319
   pragma Import (C, timegm, "timegm");

  -- Another name for `mktime'.   
   function timelocal (arg1 : access tm) return time_t;  -- /usr/include/time.h:322
   pragma Import (C, timelocal, "timelocal");

  -- Return the number of days in YEAR.   
   function dysize (arg1 : int) return int;  -- /usr/include/time.h:325
   pragma Import (C, dysize, "dysize");

  -- Pause execution for a number of nanoseconds.
  --   This function is a cancellation point and therefore not marked with
  --   __THROW.   

   function nanosleep (arg1 : System.Address; arg2 : access timespec) return int;  -- /usr/include/time.h:334
   pragma Import (C, nanosleep, "nanosleep");

  -- Get resolution of clock CLOCK_ID.   
   function clock_getres (arg1 : clockid_t; arg2 : access timespec) return int;  -- /usr/include/time.h:339
   pragma Import (C, clock_getres, "clock_getres");

  -- Get current value of clock CLOCK_ID and store it in TP.   
   function clock_gettime (arg1 : clockid_t; arg2 : access timespec) return int;  -- /usr/include/time.h:342
   pragma Import (C, clock_gettime, "clock_gettime");

  -- Set clock CLOCK_ID to value TP.   
   function clock_settime (arg1 : clockid_t; arg2 : System.Address) return int;  -- /usr/include/time.h:345
   pragma Import (C, clock_settime, "clock_settime");

  -- High-resolution sleep with the specified clock.
  --   This function is a cancellation point and therefore not marked with
  --   __THROW.   

   function clock_nanosleep
     (arg1 : clockid_t;
      arg2 : int;
      arg3 : System.Address;
      arg4 : access timespec) return int;  -- /usr/include/time.h:353
   pragma Import (C, clock_nanosleep, "clock_nanosleep");

  -- Return clock ID for CPU-time clock.   
   function clock_getcpuclockid (arg1 : sys_types_h.pid_t; arg2 : access clockid_t) return int;  -- /usr/include/time.h:358
   pragma Import (C, clock_getcpuclockid, "clock_getcpuclockid");

  -- Create new per-process timer using CLOCK_ID.   
   function timer_create
     (arg1 : clockid_t;
      arg2 : System.Address;
      arg3 : System.Address) return int;  -- /usr/include/time.h:363
   pragma Import (C, timer_create, "timer_create");

  -- Delete timer TIMERID.   
   function timer_delete (arg1 : timer_t) return int;  -- /usr/include/time.h:368
   pragma Import (C, timer_delete, "timer_delete");

  -- Set timer TIMERID to VALUE, returning old value in OVALUE.   
   function timer_settime
     (arg1 : timer_t;
      arg2 : int;
      arg3 : System.Address;
      arg4 : access itimerspec) return int;  -- /usr/include/time.h:371
   pragma Import (C, timer_settime, "timer_settime");

  -- Get current value of timer TIMERID and store it in VALUE.   
   function timer_gettime (arg1 : timer_t; arg2 : access itimerspec) return int;  -- /usr/include/time.h:376
   pragma Import (C, timer_gettime, "timer_gettime");

  -- Get expiration overrun for timer TIMERID.   
   function timer_getoverrun (arg1 : timer_t) return int;  -- /usr/include/time.h:380
   pragma Import (C, timer_getoverrun, "timer_getoverrun");

  -- Set TS to calendar time based in time base BASE.   
  -- Set to one of the following values to indicate an error.
  --     1  the DATEMSK environment variable is null or undefined,
  --     2  the template file cannot be opened for reading,
  --     3  failed to get file status information,
  --     4  the template file is not a regular file,
  --     5  an error is encountered while reading the template file,
  --     6  memory allication failed (not enough memory available),
  --     7  there is no line in the template that matches the input,
  --     8  invalid input specification Example: February 31 or a time is
  --	specified that can not be represented in a time_t (representing
  --	the time in seconds since 00:00:00 UTC, January 1, 1970)  

  -- Parse the given string as a date specification and return a value
  --   representing the value.  The templates from the file identified by
  --   the environment variable DATEMSK are used.  In case of an error
  --   `getdate_err' is set.
  --   This function is a possible cancellation point and therefore not
  --   marked with __THROW.   

  -- Since `getdate' is not reentrant because of the use of `getdate_err'
  --   and the static buffer to return the result in, we provide a thread-safe
  --   variant.  The functionality is the same.  The result is returned in
  --   the buffer pointed to by RESBUFP and in case of an error the return
  --   value is != 0 with the same values as given above for `getdate_err'.
  --   This function is not part of POSIX and therefore no official
  --   cancellation point.  But due to similarity with an POSIX interface
  --   or due to the implementation it is a cancellation point and
  --   therefore not marked with __THROW.   

end time_h;
