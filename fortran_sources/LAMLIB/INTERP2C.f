      subroutine interp2c(xtab, incx, reftab, incref, nref, xabs, tab, ntab)

      implicit none

      integer nref, ntab, incx, incref

      double precision xtab(1+(nref-1)*incx), xabs(ntab)

      complex*16 reftab(1+(nref-1)*incref), tab(ntab)

c     3-point (quadratic) interpolation in table:
c     Non-equidistant case.
c     Reference table of complex function: REFTAB(*), NREF distinct abscissae stored
c     in increasing order in XTAB. Increments incx, incref between values in XTAB 
c     and REFTAB, respectively.
c     XABS(NTAB): list of increasing abscissae between 1st and last element of
c     XTAB, where the interpolation has to be done.
c     Output: TAB(NTAB) (complex*16),
c     interpolation of the list in REFTAB at the NTAB points XABS.
 
      integer i, itab, itab1, itab2, j, ix, ix1, ix2, isrchfge

      double precision x, x1, x2, x3, a1, a2, a3, x12, x23, x13, x1x, x2x, x3x

      external isrchfge

      if(nref.lt.3)write(6,*)'error interp2c: the reference table only has', nref, ' entries' 
      if(xabs(1).lt.xtab(1) .or. xabs(ntab).gt.xtab(1+(nref-1)*incx))
     ;write(6,*)'interp2c: warning: some values lie out of interpolating range' 
     
      do 1 i = 1, ntab
      x = xabs(i)
      j = min0(isrchfge(nref, xtab, incx, x), nref-1)
      j = max0(2, j)
      ix = 1 + (j - 1) * incx
      ix1 = ix - incx
      ix2 = ix + incx
      itab = 1 + (j - 1) * incref
      itab1 = itab - incref
      itab2 = itab + incref
      x1 = xtab(ix1)
      x2 = xtab(ix)
      x3 = xtab(ix2)
      x12 = x1 - x2
      x23 = x2 - x3
      x13 = x1 - x3
      x1x = x1 - x
      x2x = x2 - x
      x3x = x3 - x
      a1 = x2x * x3x / (x12 * x13)
      a2 = x3x * x1x / (- x23 * x12)
      a3 = x1x * x2x / (x13 * x23)
c      a1 = (x2-x)*(x3-x)/((x2-x1)*(x3-x1))
c      a2 = (x3-x)*(x1-x)/((x3-x2)*(x1-x2))
c      a3 = (x1-x)*(x2-x)/((x1-x3)*(x2-x3))
      tab(i) = a1 * reftab(itab1) + a2 * reftab(itab) + a3 * reftab(itab2)
  1   continue

      return
      end
