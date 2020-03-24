# React Portal

Render/overwrite content anywhere in your application.

## Why

This library was created to cover limitations from existing solutions
(`ReactDOM.createPortal(...)`, `mui.core.Portal` from
[`material-ui`](https://lib.haxe.org/p/material-ui/)):

* Target container needed to be mounted before the content being sent there,
  which was sometimes a pain with DOM containers or contextual containers
  (inside drawers, etc.)

* No built-in way to have multiple content providers writing to the same
  container (and taking priority over one another)

## Usage

### Compatibility

This library is using some features of **Haxe 4**, and is not currently
compatible with 3.x. Compatibility _could_ be achieved, but I have no use for it
so I don't bother. Feel free to express your need for it.

**React 16.3.0** is needed because this library is using the "new context API".

As for haxe-react, this library is primarily developed for
[`react-next`](https://lib.haxe.org/p/react-next/), with any reasonably recent
version. Compatibility with `coconut.react` should be possible but is not
tested, feel free to open issues or pull requests if needed.

### Basic usage

First, you need a `react.portal.PortalProvider` near the root of your component
tree (or at least above any of your portals):

```jsx
<PortalProvider>
  {/* component tree */}
</PortalProvider>
```

Then, somewhere in your component tree you can define where to render your
content with `react.portal.PortalContainer`:

```jsx
<header>
  <h1>
    <PortalContainer id="custom-title" />
  </h1>
  <nav>
    <PortalContainer id="custom-nav" />
  </nav>
</header>
```

You can then write to those from anywhere in your component tree. Note that the
containers don't even need to exist yet when you send your content, they will
get it when they are displayed (you can have portals in mobile drawers, etc.).

To write content, use `react.portal.PortalContent`:

```jsx
<PortalContent target="custom-title">
  Hello world!
</PortalContent>
```

Note: consider using abstracts over `String` for your target ids.

### Priorities

Sometimes you want a container to have contextual content. Several content
providers can target the same container by using priorities.

You can define your absolute fallback with priority `Insignificant` (or any
other low priority, see below):

```jsx
<PortalContent target="custom-title" priority={Insignificant}>
  My application
</PortalContent>
```

But then, on your task list, you want to set it to:

```jsx
<PortalContent target="custom-title" priority={Average}>
  TODO list
</PortalContent>
```

And when inserting a new one:

```jsx
<PortalContent target="custom-title" priority={High}>
  TODO list: new task
</PortalContent>
```

When those `PortalContent` components will unmount, the highest priority amongst
remaining defined content will be displayed again.

Available priorities are, from lowest to highest:

 * `Insignificant`
 * `Lowest`
 * `Lower`
 * `Low`
 * `BelowAverage`
 * `Average` _(default priority)_
 * `AboveAverage`
 * `High`
 * `Higher`
 * `Highest`
 * `Ultimate`

## Current limitations

Both of these should be handled in a future release, but are not considered deal
breakers at the moment:

* You cannot explicitly set content to `null` for a specific priority
  (and so overriding a lower priority which has content). There is a simple
  workaround though: pass `<></>` (empty `react.Fragment`) instead.

* Multiple components writing to the same priority of the same target can
  conflict with each other: if both write content and then one of them discards
  it (either by setting to `null` or unmounting), the content will not fall back
  to the other one until it is rendered again. Workaround: use different
  priorities when possible.
