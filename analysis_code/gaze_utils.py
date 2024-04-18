import numpy as np 
import math 


def center(i, type = None, center_x = None, center_y = None):
    '''----------------------------------------------------------------------
    center(i, type, center_x, center_y)
    ---------------------------------------------------------------------- 
    Goal of the function :
    Center pixel coordinates to specific screen dimensions
    ----------------------------------------------------------------------
    Input(s) :
    i: element (float or int)
    type: string. x or y
    center_x: middle of screen x (float or int)
    center_y: center of screen y (float or int)
    ----------------------------------------------------------------------
    Output(s) :
    centered i 
    -------------------------------------------------------------------'''
    if  type == 'x':
        return i - center_x
    elif type == 'y': 
        return i - center_y
    else: 
        print("provide x or y") 
        
# Vectorized center function - will apply center function to every element in a vector 
center_applied = np.vectorize(center)

def pix2deg_x(pix):
    '''----------------------------------------------------------------------
    pix2deg_x(pix)
    ---------------------------------------------------------------------- 
    Goal of the function :
    Convert pixels in x direction to degrees of visual angle. Configured 
    for 1920 by 1080 screen.
    ----------------------------------------------------------------------
    Input(s) :
    pix: pixel value (int)
    ----------------------------------------------------------------------
    Output(s) :
    ang: pixel value converted to dva (x direction)
    -------------------------------------------------------------------'''
    pixSize =  696/1920  # mm/pix
    sz = pix * pixSize  # mm 
    ang = sz/(2*1200*math.tan(0.5*math.pi/180))
    
    return ang

# Vectorized pix2deg_x function - wil apply function to every element in a vector
pix2deg_x_applied = np.vectorize(pix2deg_x)

def pix2deg_y(pix):
    '''----------------------------------------------------------------------
    pix2deg_y(pix)
    ---------------------------------------------------------------------- 
    Goal of the function :
    Convert pixels in y direction to degrees of visual angle. Configured 
    for 1920 by 1080 screen.
    ----------------------------------------------------------------------
    Input(s) :
    pix: pixel value (int)
    ----------------------------------------------------------------------
    Output(s) :
    ang: pixel value converted to dva (y direction)
    -------------------------------------------------------------------'''
    pixSize =  391/1080  # mm/pix
    sz = pix * pixSize  # mm 
    ang = -1*(sz/(2*1200*math.tan(0.5*math.pi/180)))
    
    
    return ang

# Vectorized pix2deg_y function - wil apply function to every element in a vector
pix2deg_y_applied = np.vectorize(pix2deg_y)

def deg2pix(deg):
    '''----------------------------------------------------------------------
    deg2pix(deg)
    ---------------------------------------------------------------------- 
    Goal of the function :
    Convert degrees of visual angle to pixels in x direction. Configured 
    for 1920 by 1080 screen.
    ----------------------------------------------------------------------
    Input(s) :
    deg: degree of visual angle
    ----------------------------------------------------------------------
    Output(s) :
    pix_x: dva value converted to pixels (x direction)
    -------------------------------------------------------------------'''
    pix_by_mm_x = 1920/782
    pix_by_mm_y = 1080/440  

    cm = 2*120*math.tan(0.5*math.pi/180) * deg
    pix_X = cm * 10 * pix_by_mm_x
    pix_Y = cm * 10 * pix_by_mm_y
    
    return pix_X


def interp1d(array: np.ndarray, new_len: int) -> np.ndarray:
    '''----------------------------------------------------------------------
    interpl1d(array, new_len)
    ---------------------------------------------------------------------- 
    Goal of the function :
    interpolate an array into a new length
    ----------------------------------------------------------------------
    Input(s) :
    array: np.array to be interpolated
    new_len: new length (int)
    ----------------------------------------------------------------------
    Output(s) :
    np.array: interpolated np.array
    -------------------------------------------------------------------'''

    la = len(array)
    return np.interp(np.linspace(0, la - 1, num=new_len), np.arange(la), array)