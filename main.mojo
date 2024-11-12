from extractor.extract import PDFImageExtractor, PDFPageToImageConverter

fn main() raises:
    var pdf_path = "./extract/FT_Live_Show_Activations.pdf"  # Update this path
    var extractor = PDFImageExtractor()
    var converter = PDFPageToImageConverter()
    var extract_count = extractor.extract_images(pdf_path)
    var convert_count = converter.convert_images(pdf_path)

    print("\nExtracted", extract_count, "images")
    extractor.print_extracted_files()

    print("\nConverted", convert_count, "pages")
    converter.print_converted_files()
