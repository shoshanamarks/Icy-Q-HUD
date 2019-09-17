/*
 * File: rtwdemo_attitude.c
 *
 * Code generated for Simulink model 'rtwdemo_attitude'.
 *
 * Model version                  : 1.29
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * C/C++ source code generated on : Thu Nov 21 02:48:21 2013
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Specified
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "rtwdemo_attitude.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        (*((rtm)->errorStatus))
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   (*((rtm)->errorStatus) = (val))
#endif

#ifndef rtmGetErrorStatusPointer
# define rtmGetErrorStatusPointer(rtm) (rtm)->errorStatus
#endif

#ifndef rtmSetErrorStatusPointer
# define rtmSetErrorStatusPointer(rtm, val) ((rtm)->errorStatus = (val))
#endif

/* Disable for referenced model: 'rtwdemo_attitude' */
void rtwdemo_attitude_Disable(rtwdemo_attitude_rtDW *localDW)
{
  /* Disable for DiscreteIntegrator: '<Root>/Integrator' */
  localDW->Integrator_DSTATE = localDW->Integrator;
}

/* Output and update for referenced model: 'rtwdemo_attitude' */
void rtwdemo_attitude(const real_T *u_Disp_Cmd, const real_T *u_Disp_FB, const
                      real_T *u_Rate_FB, const boolean_T *u_Engaged, real_T
                      *y_Surf_Cmd, rtwdemo_attitude_rtDW *localDW)
{
  /* local block i/o variables */
  boolean_T rtb_NotEngaged;
  real_T rtb_Sum1;

  /* Logic: '<Root>/NotEngaged' */
  rtb_NotEngaged = !*u_Engaged;

  /* DiscreteIntegrator: '<Root>/Integrator' */
  if (rtb_NotEngaged || (localDW->Integrator_PrevResetState != 0)) {
    localDW->Integrator_DSTATE = 0.0;
  }

  if (localDW->Integrator_DSTATE >= 5.0) {
    localDW->Integrator_DSTATE = 5.0;
  } else {
    if (localDW->Integrator_DSTATE <= -5.0) {
      localDW->Integrator_DSTATE = -5.0;
    }
  }

  localDW->Integrator = localDW->Integrator_DSTATE;

  /* End of DiscreteIntegrator: '<Root>/Integrator' */

  /* Saturate: '<Root>/DispLimit' */
  if (*u_Disp_Cmd >= 30.0) {
    rtb_Sum1 = 30.0;
  } else if (*u_Disp_Cmd <= -30.0) {
    rtb_Sum1 = -30.0;
  } else {
    rtb_Sum1 = *u_Disp_Cmd;
  }

  /* Gain: '<Root>/DispGain' incorporates:
   *  Saturate: '<Root>/DispLimit'
   *  Sum: '<Root>/Sum'
   */
  rtb_Sum1 = (rtb_Sum1 - *u_Disp_FB) * 0.75;

  /* Saturate: '<Root>/RateLimit' */
  if (rtb_Sum1 >= 6.0) {
    rtb_Sum1 = 6.0;
  } else {
    if (rtb_Sum1 <= -6.0) {
      rtb_Sum1 = -6.0;
    }
  }

  /* Sum: '<Root>/Sum1' incorporates:
   *  Saturate: '<Root>/RateLimit'
   */
  rtb_Sum1 -= *u_Rate_FB;

  /* Sum: '<Root>/Sum2' incorporates:
   *  Gain: '<Root>/RateGain'
   */
  *y_Surf_Cmd = 2.0 * rtb_Sum1 + localDW->Integrator;

  /* Saturate: '<Root>/CmdLimit' */
  if (*y_Surf_Cmd >= 15.0) {
    /* Sum: '<Root>/Sum2' */
    *y_Surf_Cmd = 15.0;
  } else {
    if (*y_Surf_Cmd <= -15.0) {
      /* Sum: '<Root>/Sum2' */
      *y_Surf_Cmd = -15.0;
    }
  }

  /* End of Saturate: '<Root>/CmdLimit' */

  /* Update for DiscreteIntegrator: '<Root>/Integrator' incorporates:
   *  Gain: '<Root>/IntGain'
   */
  localDW->Integrator_DSTATE += 0.5 * rtb_Sum1 * 0.025;
  if (localDW->Integrator_DSTATE >= 5.0) {
    localDW->Integrator_DSTATE = 5.0;
  } else {
    if (localDW->Integrator_DSTATE <= -5.0) {
      localDW->Integrator_DSTATE = -5.0;
    }
  }

  if (rtb_NotEngaged) {
    localDW->Integrator_PrevResetState = 1;
  } else {
    localDW->Integrator_PrevResetState = 0;
  }

  /* End of Update for DiscreteIntegrator: '<Root>/Integrator' */
}

/* Model initialize function */
void rtwdemo_attitude_initialize(const char_T **rt_errorStatus,
  rtwdemo_attitude_RT_MODEL *const rtwdemo_attitudertM)
{
  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatusPointer(rtwdemo_attitudertM, rt_errorStatus);
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
