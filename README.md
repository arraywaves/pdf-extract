# PDF Image Tool
Extract embedded images and convert pages to images from PDFs using Mojo.

## Requirements
- Mojo
- Magic environment with:
  - pdfplumber
  - pdf2image

## Setup
```bash
# Install dependencies
magic add "pdfplumber"
magic add "pdf2image"
```

## Usage
```bash
# Run the tool (converts ./extract/target.pdf)
mojo main.mojo

# Or specify a different PDF
mojo main.mojo --pdf=/path/to/your.pdf
```

## Output
- Extracted images will be in `extracted_images/`
- Converted page images will be in `converted_images/`
