// SPDX-License-Identifier: MIT OR Apache-2.0
//
// Copyright (c) 2018-2022 Andre Richter <andre.o.richter@gmail.com>

//! Conditional reexporting of Board Support Packages.

#[cfg(feature = "bsp_rpi4")]
mod raspberrypi;

#[cfg(feature = "bsp_rpi4")]
pub use raspberrypi::*;

#[cfg(feature = "bsp_microzed")]
mod microzed;

#[cfg(feature = "bsp_microzed")]
pub use microzed::*;
