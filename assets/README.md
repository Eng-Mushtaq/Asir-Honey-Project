# Assets Directory

## Structure

```
assets/
├── images/
│   ├── logo.png (App logo)
│   ├── splash_logo.png (Splash screen logo)
│   ├── onboarding_1.png (Onboarding slide 1)
│   ├── onboarding_2.png (Onboarding slide 2)
│   ├── onboarding_3.png (Onboarding slide 3)
│   ├── empty_cart.png (Empty cart illustration)
│   ├── empty_orders.png (Empty orders illustration)
│   ├── empty_products.png (Empty products illustration)
│   └── placeholder_product.png (Product placeholder)
│
├── icons/
│   ├── honey_sidr.png (Sidr honey icon)
│   ├── honey_samar.png (Samar honey icon)
│   ├── honey_talah.png (Talah honey icon)
│   ├── honey_shoka.png (Shoka honey icon)
│   └── honey_mixed.png (Mixed honey icon)
│
└── animations/
    └── loading.json (Lottie loading animation)
```

## Note

Currently, the app uses:
- Material Icons for all icons
- Placeholder URLs for product images
- Built-in Flutter widgets for empty states

To add custom assets:
1. Place files in the appropriate directory
2. Update `pubspec.yaml` if needed
3. Reference in code using `AssetImage('assets/images/logo.png')`

## Recommended Sizes

### Images
- Logo: 512x512 px
- Splash Logo: 1024x1024 px
- Onboarding: 800x600 px
- Product Images: 800x600 px (4:3 ratio)
- Icons: 128x128 px

### Format
- PNG for images with transparency
- JPG for photos
- SVG for scalable icons
- JSON for Lottie animations
