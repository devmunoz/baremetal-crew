---
version: alpha
name: Brand Name / Theme Name
description: A short description of the theme and brand identity.
colors:
  primary: "#1A1C1E"
  secondary: "#6C7278"
  tertiary: "#B8422E"
  background: "#FFFFFF"
  surface: "#F8F9FA"
typography:
  h1:
    fontFamily: Public Sans, sans-serif
    fontSize: 48px
    fontWeight: 600
    lineHeight: 1.1
    letterSpacing: -0.02em
  body:
    fontFamily: Public Sans, sans-serif
    fontSize: 16px
    fontWeight: 400
    lineHeight: 1.5
rounded:
  sm: 4px
  md: 8px
  lg: 16px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
components:
  button:
    background: "{colors.primary}"
    color: "{colors.background}"
    borderRadius: "{rounded.md}"
---

# DESIGN.md

This document defines the visual identity, brand rationale, and style guidelines for this repository.

## Overview
A holistic description of the product's look and feel, brand personality, target audience, and the emotional response the UI should evoke.

## Colors
Description of the color palette, roles of primary/secondary/tertiary colors, contrast rules, accessibility compliance, and semantic color usage.

## Typography
Guidance on typography scales, font selection rationale, readable line heights, and hierarchy alignments.

## Layout
Rules for spacing scales, grids, margins, responsiveness guidelines, and page-level layouts.

## Elevation & Depth
Elevation scale, shadow tokens, overlays, and visual hierarchies in three dimensions.

## Shapes
Rules for rounded corners (border-radius), borders, border widths, and geometric components.

## Components
Detailed token mappings and visual guidelines for reusable interface components (e.g. Buttons, Inputs, Cards).

## Do's and Don'ts
A list of concrete visual anti-patterns and approved design practices to maintain aesthetic consistency.
