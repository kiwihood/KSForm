# KSForm
This is a Form UI framework for iOS. You can easily create kinds of forms and manage your data by sections and elements.

For iOS8 and later.
You can use a few lines to create a simple form.

KSFormViewController * controller = [[KSFormViewController alloc] init];

NSMutableArray * elements = [NSMutableArray array];
KSFormTextElement * textEle = [KSFormTextElement elementWithKey:@"name" title:@"Name" defaultValue:nil placeholder:@"Name"];
[elements addObject:textEle];
textEle = [KSFormTextElement elementWithKey:@"phone" title:@"Phone" defaultValue:nil placeholder:@"Phone"];
textEle.textField.keyboardType = UIKeyboardTypePhonePad;
[elements addObject:textEle];
textEle = [KSFormTextElement elementWithKey:@"email" title:@"Email" defaultValue:nil placeholder:@"Email Address"];
textEle.textField.keyboardType = UIKeyboardTypeEmailAddress;
[elements addObject:textEle];
KSFormMultiTextElement * mutiTextEle = [KSFormMultiTextElement elementWithKey:@"address" title:@"Address" defaultValue:nil placeholder:@"Address"];
[elements addObject:mutiTextEle];
KSFormSection * sec0 = [KSFormSection sectionWithTitle:nil elements:elements];
        
elements = [NSMutableArray array];
KSFormBooleanElement * booleanEle = [KSFormBooleanElement elementWithKey:@"share_location" title:@"Share Location" defaultValue:YES];
[elements addObject:booleanEle];
mutiTextEle = [KSFormMultiTextElement elementWithKey:@"des" title:@"Description" defaultValue:nil placeholder:@"Description"];
[elements addObject:mutiTextEle];
KSFormSection * sec1 = [KSFormSection sectionWithTitle:nil elements:elements];
        
controller.formSections = @[sec0, sec1];
        
[self.navigationController pushViewController:controller animated:YES];
