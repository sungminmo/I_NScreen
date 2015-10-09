//
//  IKTextFieldInputView.m
//  HanhwaIphone
//
//  Created by Rickseong on 2015. 8. 10..
//
//

#import "CMCustomNumberPadView.h"

@implementation CMCustomNumberPadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(IBAction)eventClick:(id)sender
{
    
    UIButton *button = (UIButton*)sender;
    
    NSString *titleText = [[button titleForState:UIControlStateNormal] lowercaseString];
    
    if( [titleText isEqualToString:@"done"] )
    {
        if (self.doneBlock) {
            self.doneBlock(self.textField);
        }
        
        [_textField resignFirstResponder];
    }
    else if( [titleText isEqualToString:@"delete"] )
    {
        
        if( _textField.delegate != NULL )
        {
            if( [_textField.text length] > 0 )
            {
                BOOL check = [_textField.delegate textField:_textField shouldChangeCharactersInRange:NSMakeRange([_textField.text length]-1, 1) replacementString:@""];
                
                if( check == TRUE )
                {
                    _textField.text = [_textField.text substringToIndex:([_textField.text length]-1)];
                }
                
            }
        }
        else
        {
            _textField.text = [_textField.text substringToIndex:([_textField.text length]-1)];
        }
        
    }
    else
    {
        
        //델리게이트가 있다면 델리게이트로 데이터를 보내 처리 한다.
        if( _textField.delegate != NULL )
        {
            BOOL check = [_textField.delegate textField:_textField shouldChangeCharactersInRange:NSMakeRange([_textField.text length], 0) replacementString:titleText];
            
            if( check == TRUE )
            {
                _textField.text = [NSString stringWithFormat:@"%@%@",_textField.text,titleText];
            }
            
        }
        else //델리게이트가 없으면 일반 숫자입력식으로 처리 한다.
        {
            _textField.text = [NSString stringWithFormat:@"%@%@",_textField.text,titleText];
        }
    }
    
    
}

@end
